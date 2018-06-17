{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 resolution;\n//example from https://www.shadertoy.com/view/MdSGRc\nfloat hash1( float n ) { return fract(sin(n)*43758.5453); }\nvec2  hash2( vec2  p ) { p = vec2( dot(p,vec2(127.1,311.7)), dot(p,vec2(269.5,183.3)) ); return fract(sin(p)*43758.5453); }\n\nuniform sampler2D backbuffer;\n\nvec4 voronoi( in vec2 x, float mode )\n{\n    vec2 n = floor( x );\n    vec2 f = fract( x );\n\n\tvec3 m = vec3( 8.0 );\n\tfloat m2 = 8.0;\n    for( int j=-2; j<=2; j++ )\n    for( int i=-2; i<=2; i++ )\n    {\n        vec2 g = vec2( float(i),float(j) );\n        vec2 o = hash2( n + g );\n\n\t\t// animate\n        o = 0.5 + 0.5*sin( time/99. + 6.2831*o );\n\n\t\tvec2 r = g - f + o;\n\n        // euclidean\t\t\n\t\tvec2 d0 = vec2( sqrt(dot(r,r)), 1.0 );\n        // triangular\t\t\n\t\tvec2 d2 = vec2( max(abs(r.x)*0.866025+r.y*0.5,-r.y), \n\t\t\t\t        step(0.0,0.5*abs(r.x)+0.866025*r.y)*(1.0+step(0.0,r.x)) );\n\n\t\tvec2 d; \n\t\td=mix( d2, d0, fract(mode) );\n\t\t\n        if( d.x<m.x )\n        {\n\t\t\tm2 = m.x;\n            m.x = d.x;\n            m.y = hash1( dot(n+g,vec2(7.0,113.0) ) );\n\t\t\tm.z = d.y;\n        }\n\t\telse if( d.x<m2 )\n\t\t{\n\t\t\tm2 = d.x;\n\t\t}\n\n    }\n    return vec4( m, m2-m.x );\n}\n\nvoid main( void ) {\n\n\t\nfloat mode = mod(time/55.0,3.0);\n\tmode = floor(mode) + smoothstep( 0.8, 1.0, fract(mode) );\n\t\n    vec2 p = gl_FragCoord.xy/resolution.xx;\n    p += cos(1./(1.+sin(p.x*3.14)) * 3. + 0.0123*time) * 0.1 - cos(1./(1.+sin(p.y*3.14))*2. +0.0234*time)*0.2;\n    p -= cos(1./(1.+sin(p.t*3.14)) * 3. + 0.0123*time) * 0.1 - cos(1./(1.+sin(p.x*3.14))*2. +0.0243*time)*0.2;\nvec4 c = voronoi( 8.0*p, 2. );\n\n    vec3 col = 0.5 + 0.5*sin( c.y*21.5 + vec3(11.0,1.0,1.9) );\n    col *= sqrt( clamp( 1.0 - c.x, 0.0, 1.0 ) );\n\tcol *= clamp( 0.5 + (1.0-c.z/2.0)*0.5, 0.0, 1.0 );\n\tcol *= 0.4 + 0.6*sqrt(clamp( 4.0*c.w, 0.0, 1.0 ));\n\t\n\t\n    gl_FragColor = vec4( col, 1.0 );\n\t\n\t#define texture2D_D(D) texture2D(backbuffer, fract((D+gl_FragCoord.xy)/resolution))\n\tvec4 lastColor = max(texture2D_D(vec2(0)), pow(texture2D_D(vec2(1,0)) * texture2D_D(vec2(0,1)) * texture2D_D(vec2(0,-1)) * texture2D_D(vec2(-1,0)), vec4(1.)/4.));\n\tvec4 diffColor = gl_FragColor-lastColor;\n\tgl_FragColor.rgb = lastColor.rgb + sign(diffColor.rgb) * 1./256.;\n}", "user": "8dacf50", "parent": "/e#47215.0", "id": 47217}