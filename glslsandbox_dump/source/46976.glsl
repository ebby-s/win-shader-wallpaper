{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n#extension GL_OES_standard_derivatives : enable\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n#define AA 1   // make this 1 is your machine is too slow\n//------------------------------------------------------------------\nfloat sdPlane( vec3 p )\n{\n\treturn p.y;\n}\nfloat sdSphere( vec3 p, float s )\n{\n    return length(p)-s;\n}\nfloat length2( vec2 p )\n{\n\treturn sqrt( 2.0*p.x*p.x + p.y*p.y );\n}\nfloat length6( vec2 p )\n{\n\tp = p*p*p; p = p*p;\n\treturn pow( p.x + p.y, 1.0/6.0 );\n}\nfloat length8( vec2 p )\n{\n\tp = p*p; p = p*p; p = p*p;\n\treturn pow( p.x + p.y, 1.0/8.0 );\n}\n//------------------------------------------------------------------\nfloat opS( float d1, float d2 )\n{\n    return max(-d2,d1);\n}\nvec2 opU( vec2 d1, vec2 d2 )\n{\n\treturn (d1.x<d2.x) ? d1 : d2;\n}\nvec3 opRep( vec3 p, vec3 c )\n{\n    return mod(p,c)-0.5*c;\n}\nvec3 opTwist( vec3 p )\n{\n    float  c = cos(10.0*p.y+10.0);\n    float  s = sin(10.0*p.y+10.0);\n    mat2   m = mat2(c,-s,s,c);\n    return vec3(m*p.xz,p.y);\n}\n//------------------------------------------------------------------\nvec2 map( in vec3 pos )\n{\n    vec2 res = opU( vec2( sdPlane(     pos), 1.0 ), vec2( 0.5*sdSphere(    pos-vec3(0.0,0.7,0.0), 0.6 ) + 0.05*sin(50.0*pos.x)*sin(50.0*pos.y)*sin(50.0*pos.z), 90.0 ) );\n       return res;\n}\nvec2 castRay( in vec3 ro, in vec3 rd )\n{\n    float tmin = 1.0;\n    float tmax = 20.0;\n   #if 1\n    // bounding volume\n    float tp1 = (0.0-ro.y)/rd.y; if( tp1>0.0 ) tmax = min( tmax, tp1 );\n    float tp2 = (1.6-ro.y)/rd.y; if( tp2>0.0 ) { if( ro.y>1.6 ) tmin = max( tmin, tp2 );\n                                                 else           tmax = min( tmax, tp2 ); }\n#endif\n    float t = tmin;\n    float m = -1.0;\n    for( int i=0; i<64; i++ )\n    {\n\t    float precis = 0.0005*t;\n\t    vec2 res = map( ro+rd*t );\n        if( res.x<precis || t>tmax ) break;\n        t += res.x;\n\t    m = res.y;\n    }\nif( t>tmax ) m=-1.0;\n    return vec2( t, m );\n}\nfloat calcSoftshadow( in vec3 ro, in vec3 rd, in float mint, in float tmax )\n{\n\tfloat res = 1.0;\n    float t = mint;\n    for( int i=0; i<16; i++ )\n    {\n\t\tfloat h = map( ro + rd*t ).x;\n        res = min( res, 8.0*h/t );\n        t += clamp( h, 0.02, 0.10 );\n        if( h<0.001 || t>tmax ) break;\n    }\n    return clamp( res, 0.0, 1.0 );\n}\nvec3 calcNormal( in vec3 pos )\n{\n    vec2 e = vec2(1.0,-1.0)*0.5773*0.0005;\n    return normalize( e.xyy*map( pos + e.xyy ).x + \n\t\t\t\t\t  e.yyx*map( pos + e.yyx ).x + \n\t\t\t\t\t  e.yxy*map( pos + e.yxy ).x + \n\t\t\t\t\t  e.xxx*map( pos + e.xxx ).x );\n    /*\n\tvec3 eps = vec3( 0.0005, 0.0, 0.0 );\n\tvec3 nor = vec3(\n\t    map(pos+eps.xyy).x - map(pos-eps.xyy).x,\n\t    map(pos+eps.yxy).x - map(pos-eps.yxy).x,\n\t    map(pos+eps.yyx).x - map(pos-eps.yyx).x );\n\treturn normalize(nor);\n\t*/\n}\nfloat calcAO( in vec3 pos, in vec3 nor )\n{\n\tfloat occ = 0.0;\n    float sca = 1.0;\n    for( int i=0; i<5; i++ )\n    {\n        float hr = 0.01 + 0.12*float(i)/4.0;\n        vec3 aopos =  nor * hr + pos;\n        float dd = map( aopos ).x;\n        occ += -(dd-hr)*sca;\n        sca *= 0.95;\n    }\n    return clamp( 1.0 - 3.0*occ, 0.0, 1.0 );    \n}\n// http://iquilezles.org/www/articles/checkerfiltering/checkerfiltering.htm\nfloat checkersGradBox( in vec2 p )\n{\n    // filter kernel\n    vec2 w = fwidth(p) + 0.001;\n    // analytical integral (box filter)\n    vec2 i = 2.0*(abs(fract((p-0.5*w)*0.5)-0.5)-abs(fract((p+0.5*w)*0.5)-0.5))/w;\n    // xor pattern\n    return 0.5 - 0.5*i.x*i.y;                  \n}\nvec3 render( in vec3 ro, in vec3 rd )\n{ \n    vec3 col = vec3(0.7, 0.9, 1.0) +rd.y*0.8;\n    vec2 res = castRay(ro,rd);\n    float t = res.x;\n\tfloat m = res.y;\n    if( m>-0.5 )\n    {\n        vec3 pos = ro + t*rd;\n        vec3 nor = calcNormal( pos );\n        vec3 ref = reflect( rd, nor );\n        // material        \n\t\tcol = 0.45 + 0.35*sin( vec3(0.05,0.08,0.10)*(m-1.0) );\n        if( m<1.5 )\n        {\n            float f = checkersGradBox( 5.0*pos.xz );\n            col = 0.3 + f*vec3(0.1);\n        }\n// lighitng        \n        float occ = calcAO( pos, nor );\n\t\tvec3  lig = normalize( vec3(-0.4, 0.7, -0.6) );\n        vec3  hal = normalize( lig-rd );\n\t\tfloat amb = clamp( 0.5+0.5*nor.y, 0.0, 1.0 );\n        float dif = clamp( dot( nor, lig ), 0.0, 1.0 );\n        float bac = clamp( dot( nor, normalize(vec3(-lig.x,0.0,-lig.z))), 0.0, 1.0 )*clamp( 1.0-pos.y,0.0,1.0);\n        float dom = smoothstep( -0.1, 0.1, ref.y );\n        float fre = pow( clamp(1.0+dot(nor,rd),0.0,1.0), 2.0 );\n        dif *= calcSoftshadow( pos, lig, 0.02, 2.5 );\n        dom *= calcSoftshadow( pos, ref, 0.02, 2.5 );\n\t    float spe = pow( clamp( dot( nor, hal ), 0.0, 1.0 ),16.0)*\n                    dif *\n                    (0.04 + 0.96*pow( clamp(1.0+dot(hal,rd),0.0,1.0), 5.0 ));\n\t    vec3 lin = vec3(0.0);\n        lin += 1.30*dif*vec3(1.00,0.80,0.55);\n        lin += 0.40*amb*vec3(0.40,0.60,1.00)*occ;\n        lin += 0.50*dom*vec3(0.40,0.60,1.00)*occ;\n        lin += 0.50*bac*vec3(0.25,0.25,0.25)*occ;\n        lin += 0.25*fre*vec3(1.00,1.00,1.00)*occ;\n\t\tcol = col*lin;\n\t\tcol += 10.00*spe*vec3(1.00,0.90,0.70);\n                col = mix( col, vec3(0.8,0.9,1.0), 1.0-exp( -0.0002*t*t*t ) );\n    }\nreturn vec3( clamp(col,0.0,1.0) );\n}\nmat3 setCamera( in vec3 ro, in vec3 ta, float cr )\n{\n\tvec3 cw = normalize(ta-ro);\n\tvec3 cp = vec3(sin(cr), cos(cr),0.0);\n\tvec3 cu = normalize( cross(cw,cp) );\n\tvec3 cv = normalize( cross(cu,cw) );\n    return mat3( cu, cv, cw );\n}\nvoid main( void )\n{\n\tvec2 fragCoord = gl_FragCoord.xy;\t\t\n\tvec2 iResolution = resolution.xy;\n\tvec2 iMouse = mouse;\n\tfloat iTime = time;\n\tvec2 mo = iMouse.xy/iResolution.xy;\n\tfloat time = 15.0 + iTime;\n vec3 tot = vec3(0.0);\n#if AA>1\n    for( int m=0; m<AA; m++ )\n    for( int n=0; n<AA; n++ )\n    {\n        // pixel coordinates\n        vec2 o = vec2(float(m),float(n)) / float(AA) - 0.5;\n        vec2 p = (-iResolution.xy + 2.0*(fragCoord+o))/iResolution.y;\n#else    \n        vec2 p = (-iResolution.xy + 2.0*fragCoord)/iResolution.y;\n#endif\n\t\t// camera\t\n        vec3 ro = vec3( -0.5+3.5*cos(0.1*time + 6.0*mo.x), 1.0 + 2.0*mo.y, 0.5 + 4.0*sin(0.1*time + 6.0*mo.x) );\n        vec3 ta = vec3( 0.0, 0.0, 0.0 );\n        // camera-to-world transformation\n        mat3 ca = setCamera( ro, ta, 0.0 );\n        // ray direction\n        vec3 rd = ca * normalize( vec3(p.xy,2.0) );\n// render\t\n        vec3 col = render( ro, rd );\n\t    // gamma\n        col = pow( col, vec3(0.4545) );\n        tot += col;\n#if AA>1\n    }\n    tot /= float(AA*AA);\n#endif\n    gl_FragColor = vec4( tot, 1.0 );\n}", "user": "3ea74a7", "parent": "/e#46974.4", "id": 46976}