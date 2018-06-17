{"code": "// ported by vitos1k\n// it's a port from Shader toy Structured Volume sampling  https://www.shadertoy.com/view/Mt3GWs \n// in the original there was noise texture iChannel0 used to generate some 3d noise.\n// i used float noise(vec3) from this example http://glslsandbox.com/e#35155.0   to generate some random noise\n\n\n\n\n/*\nThe MIT License (MIT)\n\nCopyright (c) 2016 Huw Bowles, Daniel Zimmermann, Beibei Wang\n\nPermission is hereby granted, free of charge, to any person obtaining a copy\nof this software and associated documentation files (the \"Software\"), to deal\nin the Software without restriction, including without limitation the rights\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell\ncopies of the Software, and to permit persons to whom the Software is\nfurnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\nSOFTWARE.\n*/\n\n//\n// For diagram shader showing how samples are taken:\n//\n// https://www.shadertoy.com/view/ll3GWs\n//\n// We are in the process of writing up this technique. The following github repos\n// is the home of this research.\n//\n// https://github.com/huwb/volsample\n//\n// \n//\n// Additional credits - this scene is mostly mash up of these two amazing shaders:\n//\n// Clouds by iq: https://www.shadertoy.com/view/XslGRr\n// Cloud Ten by nimitz: https://www.shadertoy.com/view/XtS3DD\n// \n\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\nuniform sampler2D backbuffer;\n\n\n#define SAMPLE_COUNT 32\n#define PERIOD 1.\n#define SEED 1337.37\n\n\n// mouse toggle\nbool STRUCTURED = true;\n\n// cam moving in a straight line\nvec3 lookDir;\nvec3 camVel = vec3(-20.,0.,0.);\nfloat zoom = 1.5; // 1.5;\n\nvec3 sundir = normalize(vec3(-1.0,0.0,-1.));\n\n// Noise salvaged from here http://glslsandbox.com/e#35155.0\n\nfloat rand(vec3 co)\n{\n\treturn fract(sin(dot(co.xyz, vec3(12.9898, 78.233, 56.787))) * 43758.5453);\n}\n\n\nfloat noise(vec3 pos)\n{\n\tvec3 ip = floor(pos);\n\tvec3 fp = smoothstep(0.0, 1.0, fract(pos));\n\tvec4 a = vec4(\n\t\trand(ip + vec3(0, 0, 0)),\n\t\trand(ip + vec3(1, 0, 0)),\n\t\trand(ip + vec3(0, 1, 0)),\n\t\trand(ip + vec3(1, 1, 0)));\n\tvec4 b = vec4(\n\t\trand(ip + vec3(0, 0, 1)),\n\t\trand(ip + vec3(1, 0, 1)),\n\t\trand(ip + vec3(0, 1, 1)),\n\t\trand(ip + vec3(1, 1, 1)));\n \n\ta = mix(a, b, fp.z);\n\ta.xy = mix(a.xy, a.zw, fp.y);\n\treturn mix(a.x, a.y, fp.x);\n}\n\n\nvec4 map( in vec3 p )\n{\n\tfloat d = 0.1 + .8 * sin(0.6*p.z)*sin(0.5*p.x) - p.y;\n\n    vec3 q = p;\n    float f;\n    \n    f  = 0.5000*noise( q ); q = q*2.02;\n    f += 0.2500*noise( q ); q = q*2.03;\n    f += 0.1250*noise( q ); q = q*2.01;\n    f += 0.0625*noise( q );\n    d += 2.75 * f;\n\n    d = clamp( d, 0.0, 1.0 );\n    \n    vec4 res = vec4( d );\n    \n    vec3 col = 1.15 * vec3(1.0,0.95,0.8);\n    col += vec3(1.,0.,0.) * exp2(res.x*10.-10.);\n    res.xyz = mix( col, vec3(0.7,0.7,0.7), res.x );\n    \n    return res;\n}\n\n\n// to share with unity hlsl\n#define float2 vec2\n#define float3 vec3\n#define fmod mod\nfloat mysign( float x ) { return x < 0. ? -1. : 1. ; }\nfloat2 mysign( float2 x ) { return float2( x.x < 0. ? -1. : 1., x.y < 0. ? -1. : 1. ) ; }\n\n// compute ray march start offset and ray march step delta and blend weight for the current ray\nvoid SetupSampling( out float2 t, out float2 dt, out float2 wt, in float3 ro, in float3 rd )\n{\n    if( !STRUCTURED )\n    {\n        dt = float2(PERIOD,PERIOD);\n        t = dt;\n        wt = float2(0.10,0.5);\n        return;\n    }\n    \n    // the following code computes intersections between the current ray, and a set\n    // of (possibly) stationary sample planes.\n    \n    // much of this should be more at home on the CPU or in a VS.\n    \n    // structured sampling pattern line normals\n    float3 n0 = (abs( rd.x ) > abs( rd.z )) ? float3(1., 0., 0.) : float3(0., 0., 1.); // non diagonal\n    float3 n1 = float3(mysign( rd.x * rd.z ), 0., 1.); // diagonal\n\n    // normal lengths (used later)\n    float2 ln = float2(length( n0 ), length( n1 ));\n    n0 /= ln.x;\n    n1 /= ln.y;\n\n    // some useful DPs\n    float2 ndotro = float2(dot( ro, n0 ), dot( ro, n1 ));\n    float2 ndotrd = float2(dot( rd, n0 ), dot( rd, n1 ));\n\n    // step size\n    float2 period = ln * PERIOD;\n    dt = period / abs( ndotrd );\n\n    // dist to line through origin\n    float2 dist = abs( ndotro / ndotrd );\n\n    // raymarch start offset - skips leftover bit to get from ro to first strata lines\n    t = -mysign( ndotrd ) * fmod( ndotro, period ) / abs( ndotrd );\n    if( ndotrd.x > 0. ) t.x += dt.x;\n    if( ndotrd.y > 0. ) t.y += dt.y;\n\n    // sample weights\n    float minperiod = PERIOD;\n    float maxperiod = sqrt( 2. )*PERIOD;\n    wt = smoothstep( maxperiod, minperiod, dt/ln );\n    wt /= (wt.x + wt.y);\n}\n\nvec4 raymarch( in vec3 ro, in vec3 rd )\n{\n    vec4 sum = vec4(0, 0, 0, 0);\n    \n    // setup sampling - compute intersection of ray with 2 sets of planes\n    float2 t, dt, wt;\n\tSetupSampling( t, dt, wt, ro, rd );\n    \n    // fade samples at far extent\n    float f = .6; // magic number - TODO justify this\n    float endFade = f*float(SAMPLE_COUNT)*PERIOD;\n    float startFade = .8*endFade;\n    \n    for(int i=0; i<SAMPLE_COUNT; i++)\n    {\n        if( sum.a > 0.99 ) continue;\n\n        // data for next sample\n        vec4 data = t.x < t.y ? vec4( t.x, wt.x, dt.x, 0. ) : vec4( t.y, wt.y, 0., dt.y );\n        // somewhat similar to: https://www.shadertoy.com/view/4dX3zl\n        //vec4 data = mix( vec4( t.x, wt.x, dt.x, 0. ), vec4( t.y, wt.y, 0., dt.y ), float(t.x > t.y) );\n        vec3 pos = ro + data.x * rd;\n        float w = data.y;\n        t += data.zw;\n        \n        // fade samples at far extent\n        w *= smoothstep( endFade, startFade, data.x );\n        \n        vec4 col = map( pos );\n        \n        // iqs goodness\n        float dif = clamp((col.w - map(pos+0.6*sundir).w)/0.6, 0.0, 1.0 );\n        vec3 lin = vec3(0.51, 0.53, 0.63)*1.35 + 0.55*vec3(0.85, 0.57, 0.3)*dif;\n        col.xyz *= lin;\n        \n        col.xyz *= col.xyz;\n        \n        col.a *= 0.75;\n        col.rgb *= col.a;\n\n        // integrate. doesn't account for dt yet, wip.\n        sum += col * (1.0 - sum.a) * w;\n    }\n\n    sum.xyz /= (0.001+sum.w);\n\n    return clamp( sum, 0.0, 1.0 );\n}\n\nvec3 sky( vec3 rd )\n{\n    vec3 col = vec3(0.);\n    \n    float hort = 1. - clamp(abs(rd.y), 0., 1.);\n    col += 0.5*vec3(.99,.5,.0)*exp2(hort*8.-8.);\n    col += 0.1*vec3(.5,.9,1.)*exp2(hort*3.-3.);\n    col += 0.55*vec3(.6,.6,.9);\n    \n    float sun = clamp( dot(sundir,rd), 0.0, 1.0 );\n    col += .2*vec3(1.0,0.3,0.2)*pow( sun, 2.0 );\n    col += .5*vec3(1.,.9,.9)*exp2(sun*650.-650.);\n    col += .1*vec3(1.,1.,0.1)*exp2(sun*100.-100.);\n    col += .3*vec3(1.,.7,0.)*exp2(sun*50.-50.);\n    col += .5*vec3(1.,0.3,0.05)*exp2(sun*10.-10.); \n    \n    float ax = atan(rd.y,length(rd.xz))/1.;\n    float ay = atan(rd.z,rd.x)/2.;\n    float st = noise( vec3(ax,ay,1.0) );\n    float st2 = noise( .25*vec3(ax,ay,0.5) );\n    st *= st2;\n    st = smoothstep(0.65,.9,st);\n    col = mix(col,col+1.8*st,clamp(1.-1.1*length(col),0.,1.));\n    \n    return col;\n}\n\n\nvoid main( void ) {\n\n    lookDir = vec3(cos(.53*time),0.,sin(time));\t\n    vec2 q = gl_FragCoord.xy / resolution.xy;\n    vec2 p = -1.0 + 2.0*q;\n    p.x *= resolution.x/ resolution.y;\n    vec2 mo = -1.0 + 2.0*mouse.xy / resolution.xy;\n   \n    // camera\n    vec3 ro = vec3(0.,1.5,0.) + 0.01*time*camVel;\n    vec3 ta = ro + lookDir; //vec3(ro.x, ro.y, ro.z-1.);\n    vec3 ww = normalize( ta - ro);\n    vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));\n    vec3 vv = normalize(cross(ww,uu));\n    float fov = 1.;\n    vec3 rd = normalize( fov*p.x*uu + fov*1.2*p.y*vv + 1.5*ww );\n    \n    // divide by forward component to get fixed z layout instead of fixed dist layout\n    //vec3 rd_layout = rd/mix(dot(rd,ww),1.0,samplesCurvature);\n    vec4 clouds = raymarch( ro, rd );\n    \n    vec3 col = clouds.xyz;\n        \n    // sky if visible\n    if( clouds.w <= 0.99 )\n\t    col = mix( sky(rd), col, clouds.w );\n    \n\tcol = clamp(col, 0., 1.);\n    col = smoothstep(0.,1.,col);\n\tcol *= pow( 16.0*q.x*q.y*(1.0-q.x)*(1.0-q.y), 0.12 ); //Vign\n        \n    gl_FragColor = vec4( col, 1.0 );\n\n}", "user": "28d0b3c", "parent": "/e#35214.0", "id": "35245.1"}