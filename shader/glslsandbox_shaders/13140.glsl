{"code": "#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform vec2 resolution;\nuniform float time;\n\nmat3 m = mat3( 0.00,  0.80,  0.60,\n              -0.80,  0.36, -0.48,\n              -0.60, -0.48,  0.64 );\n\nfloat hash( float n )\n{\n    return fract(sin(n)*43758.5453);\n}\n\n\nfloat noise( in vec3 x )\n{\n    vec3 p = floor(x);\n    vec3 f = fract(x);\n\n    f = f*f*(3.0-2.0*f);\n\n    float n = p.x + p.y*57.0 + 113.0*p.z;\n\n    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),\n                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),\n                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),\n                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);\n    return res;\n}\n\nfloat fbm( vec3 p )\n{\n    float f = 0.0;\n    p += vec3(sin(time/2.0),\n\t      sin(time/2.0),\n\t      sin(time/2.0));\n\t\n    f += 0.5000*noise( p ); p = m*p*2.02;\n    f += 0.2500*noise( p ); p = m*p*2.03;\n    f += 0.1250*noise( p ); p = m*p*2.01;\n    f += 0.0625*noise( p );\n\n    return f/0.9375;\n}\n\nvec2 map( vec3 p )\n{\n   vec2 d2 = vec2( p.y+0.55, 2.0 );\n\n   p.y -= 0.75*pow(dot(p.xz,p.xz),0.2);\n   vec2 d1 = vec2( length(p) - 1.0, 1.0 );\n\n   if( d2.x<d1.x) d1=d2;\n   return d1;\n}\n\n\nvec3 appleColor( in vec3 pos, in vec3 nor, out vec2 spe )\n{\n    spe.x = 1.0;\n    spe.y = 1.0;\n\n    float a = atan(pos.x,pos.z);\n    float r = length(pos.xz);\n\n    // red\n    vec3 col = vec3(1.0,0.0,0.0);\n\n    // green\n    float f = smoothstep( 0.1, 1.0, fbm(pos*1.0) );\n    col = mix( col, vec3(0.8,1.0,0.2), f );\n\n    // dirty\n    f = smoothstep( 0.0, 1.0, fbm(pos*4.0) );\n    col *= 0.8+0.2*f;\n\n    // frekles\n    f = smoothstep( 0.0, 1.0, fbm(pos*48.0) );\n    f = smoothstep( 0.7,0.9,f);\n    col = mix( col, vec3(0.9,0.9,0.6), f*0.5 );\n\n    // stripes\n    f = fbm( vec3(a*7.0 + pos.z,3.0*pos.y,pos.x)*2.0);\n    f = smoothstep( 0.2,1.0,f);\n    f *= smoothstep(0.4,1.2,pos.y + 0.75*(noise(4.0*pos.zyx)-0.5) );\n    col = mix( col, vec3(0.4,0.2,0.0), 0.5*f );\n    spe.x *= 1.0-0.35*f;\n    spe.y = 1.0-0.5*f;\n\n    // top\n    f = 1.0-smoothstep( 0.14, 0.2, r );\n    col = mix( col, vec3(0.6,0.6,0.5), f );\n    spe.x *= 1.0-f;\n\n\n    float ao = 0.5 + 0.5*nor.y;\n    col *= ao*1.2;\n\n    return col;\n}\n\nvec3 floorColor( in vec3 pos, in vec3 nor, out vec2 spe )\n{\n    spe.x = 1.0;\n    spe.y = 1.0;\n    vec3 col = vec3(0.5,0.4,0.3)*1.7;\n\n    float f = fbm( 4.0*pos*vec3(6.0,0.0,0.5) );\n    col = mix( col, vec3(0.3,0.2,0.1)*1.7, f );\n    spe.y = 1.0 + 4.0*f;\n\n    f = fbm( 2.0*pos );\n    col *= 0.7+0.3*f;\n\n    // frekles\n    f = smoothstep( 0.0, 1.0, fbm(pos*48.0) );\n    f = smoothstep( 0.7,0.9,f);\n    col = mix( col, vec3(0.2), f*0.75 );\n\n    // fake ao\n    f = smoothstep( 0.1, 1.55, length(pos.xz) );\n    col *= f*f*1.4;\n    col.x += 0.1*(1.0-f);\n    return col;\n}\n\nvec2 intersect( in vec3 ro, in vec3 rd )\n{\n    float t=0.0;\n    float dt = 0.06;\n    float nh = 0.0;\n    float lh = 0.0;\n    float lm = -1.0;\n    for(int i=0;i<100;i++)\n    {\n        vec2 ma = map(ro+rd*t);\n        nh = ma.x;\n        if(nh>0.0) { lh=nh; t+=dt;  } lm=ma.y;\n    }\n\n    if( nh>0.0 ) return vec2(-1.0);\n    t = t - dt*nh/(nh-lh);\n\n    return vec2(t,lm);\n}\n\nfloat softshadow( in vec3 ro, in vec3 rd, float mint, float maxt, float k )\n{\n    float res = 1.0;\n    float dt = 0.1;\n    float t = mint;\n    for( int i=0; i<30; i++ )\n    {\n        float h = map(ro + rd*t).x;\n        if( h>0.001 )\n            res = min( res, k*h/t );\n        else\n            res = 0.0;\n        t += dt;\n    }\n    return res;\n}\nvec3 calcNormal( in vec3 pos )\n{\n    vec3  eps = vec3(.001,0.0,0.0);\n    vec3 nor;\n    nor.x = map(pos+eps.xyy).x - map(pos-eps.xyy).x;\n    nor.y = map(pos+eps.yxy).x - map(pos-eps.yxy).x;\n    nor.z = map(pos+eps.yyx).x - map(pos-eps.yyx).x;\n    return normalize(nor);\n}\n\nvoid main(void)\n{\n    vec2 q = gl_FragCoord.xy / resolution.xy;\n    vec2 p = -1.0 + 2.0 * q;\n    p.x *= resolution.x/resolution.y;\n \n    // camera\n    vec3 ro = 2.5*normalize(vec3(cos(0.2*time),1.15+0.4*cos(time*.11),sin(0.2*time)));\n    vec3 ww = normalize(vec3(0.0,0.5,0.0) - ro);\n    vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));\n    vec3 vv = normalize(cross(ww,uu));\n    vec3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww );\n\n    // raymarch\n    vec3 col = vec3(0.96,0.98,1.0);\n    vec2 tmat = intersect(ro,rd);\n    if( tmat.y>0.5 )\n    {\n        // geometry\n        vec3 pos = ro + tmat.x*rd;\n        vec3 nor = calcNormal(pos);\n        vec3 ref = reflect(rd,nor);\n        vec3 lig = normalize(vec3(1.0,0.8,-0.6));\n     \n        float con = 1.0;\n        float amb = 0.5 + 0.5*nor.y;\n        float dif = max(dot(nor,lig),0.0);\n        float bac = max(0.2 + 0.8*dot(nor,vec3(-lig.x,lig.y,-lig.z)),0.0);\n        float rim = pow(1.0+dot(nor,rd),3.0);\n        float spe = pow(clamp(dot(lig,ref),0.0,1.0),16.0);\n\n        // shadow\n        float sh = softshadow( pos, lig, 0.06, 4.0, 4.0 );\n\n        // lights\n        col  = 0.10*con*vec3(0.80,0.90,1.00);\n        col += 0.70*dif*vec3(1.00,0.97,0.85)*vec3(sh, (sh+sh*sh)*0.5, sh*sh );\n        col += 0.15*bac*vec3(1.00,0.97,0.85);\n        col += 0.20*amb*vec3(0.10,0.15,0.20);\n\n\n        // color\n        vec2 pro;\n        if( tmat.y<1.5 )\n        col *= appleColor(pos,nor,pro);\n        else\n        col *= floorColor(pos,nor,pro);\n\n        // rim and spec\n        col += 0.60*rim*vec3(1.0,0.97,0.85)*amb*amb;\n        col += 0.60*pow(spe,pro.y)*vec3(1.0)*pro.x*sh;\n\n        col = 0.3*col + 0.7*sqrt(col);\n    }\n\n    col *= 0.25 + 0.75*pow( 16.0*q.x*q.y*(1.0-q.x)*(1.0-q.y), 0.15 );\n\n    gl_FragColor = vec4(col,1.0);\n}", "user": "6b951f0", "parent": "/e#785", "id": "13140.0"}