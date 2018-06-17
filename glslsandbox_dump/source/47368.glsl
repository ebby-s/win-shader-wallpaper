{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n#define EPS 0.001\n#define STEPS 128\n#define FAR  100.\n#define KIFS   30\n\nmat2 rot( float a )\n{\n\n\treturn mat2( cos( a ), -sin( a ),\n\t\t     sin( a ),  cos( a )\n\t\t   );\n\n}\n\nfloat map( vec3 p )\n{\n\n\tmat3 rota = mat3( 1.0 );\n\t\n\tfor( int i = 0; i < KIFS; ++i )\n\t{\n\t\n\t\tp = abs( p * rota - vec3( 0.1, 0.0, 0.0 ) );\n\t\tp.xy = p.yx;\n\t\t\n\t\tp.xz *= rot( 1.0 + mouse.x );\n\t\tp.yx *= rot( 2.0 + mouse.y );\n\t\n\t}\n\t\n\treturn 1.0 - length( p ); \n\n}\n\nvec3 norm( vec3 p )\n{\n\n\tvec2 e = vec2( EPS, 0.0 );\n\treturn normalize( vec3( map( p + e.xyy ) - map( p - e.xyy ),\n\t\t\t        map( p + e.yxy ) - map( p - e.yxy ),\n\t\t\t        map( p + e.yyx ) - map( p - e.yyx )\n\t\t\t      )\n\t\t\t);\n\n}\n\nfloat ray( vec3 ro, vec3 rd, out float d )\n{\n\n\tfloat t = 0.0; d = 0.0;\n\t\n\tfor( int i = 0; i < STEPS; ++i )\n\t{\n\t\n\t\td = map( ro + rd * t );\n\t\tif( d < EPS || t > FAR ) break;\n\t\t\n\t\tt += d;\n\t\n\t}\n\t\n\treturn t;\n\n}\n\nvec3 shad( vec3 ro, vec3 rd )\n{\n\n\tfloat d = 0.0, t = ray( ro, rd, d );\n\tvec3 p = ro + rd * t;\n\tvec3 n = norm( p );\n\tvec3 lig = normalize( vec3( sin( time ), 1.0, cos( time ) ) );\n\tvec3 ref = reflect( rd, n );\n\tvec3 col = vec3( 0 );\n\t\n\tfloat amb = 0.5 + 0.5 * n.y;\n\tfloat dif = max( 0.0,  dot( lig, n ) );\n\tfloat spe = pow( clamp( dot( ref, lig ), 0.0, 1.0 ), 16.0 );\n\t\n\tcol += 0.8 * amb;\n\tcol += 0.2 * dif;\n\tcol += 0.4 * spe;\n\t\n\treturn col;\n\n}\n\nvoid main( void ) {\n\n\tvec2 uv = ( -resolution.xy + 2.0 * gl_FragCoord.xy ) / resolution.y;\n\n\tvec3 ro = vec3( 0.0, 0.0, 2.4 );\n\tvec3 ww = normalize( vec3( 0 ) - ro );\n\tvec3 uu = normalize( cross( vec3( 0, 1, 0 ), ww ) );\n\tvec3 vv = normalize( cross( ww, uu ) );\n\tvec3 rd = normalize( uv.x * uu + uv.y * vv + 1.5 * ww );\n\t\n\t//vec3 rd = normalize( vec3( uv, -1.0 ) );\n\t\n\tfloat d = 0.0, t = ray( ro, rd, d );\n\t\n\tvec3 col = d < EPS ? shad( ro, rd ) : vec3( 0.0 );\n\n\tgl_FragColor = vec4( vec3( col ), 1.0 );\n\n}", "user": "c87e2a4", "parent": null, "id": 47368}