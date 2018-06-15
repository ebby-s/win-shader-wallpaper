{"code": "//Twister thing  /Harley version...\n\nprecision highp float;\n\nuniform float time;\nuniform vec2 touch;\nuniform vec2 resolution;\n\nfloat pi = atan(1.0)*4.0;\nfloat pi2 = atan(1.0)*9.0;//try time!\n\nvec3 pattern(vec2 uv)\n{\n\tfloat checker = float(sin(uv.x*pi2*4.0) * sin(uv.y*pi2*8.0) > 0.0) * 0.5 + 0.5;\n\tfloat edges = 1.0 - abs(0.5 - uv.x)*2.0;\n\tedges = (edges*0.5+0.5)*smoothstep(0.1,0.2,edges);\n\treturn vec3(checker * edges);\n}\n\nvec4 scanLine(float x0,float x1,vec2 uv)\n{\n\tvec3 texture = pattern(vec2((uv.x - x0)/(x1-x0),uv.y));\n\tfloat clip = float(x1 > x0 && uv.x > x0 && uv.x < x1);\n\treturn vec4(texture*clip,clip);\n}\n\nvoid main( void )\n{\n\tvec2 res = vec2(resolution.x/resolution.y,1.0);\n\tvec2 uv = (gl_FragCoord.xy/resolution.y) - res/4.0;\n\n\tuv.x -= sin(uv.y * 3.0 +time)*0.5;\n\n\tfloat ang = time + uv.y*cos(time)*9.0;\n\n\tfloat size = 0.35;\n\tfloat x0 = cos(ang + pi2 * 0.00) * size;\n\tfloat x1 = cos(ang + pi2 * 0.25) * size;\n\tfloat x2 = cos(ang + pi2 * 0.50) * size;\n\tfloat x3 = cos(ang + pi2 * 0.75) * size;\n\n\tvec4 col = vec4(0.0);\n\n\tcol += scanLine(x0,x1,uv) * vec4(1,5,8,1);\n\tcol += scanLine(x1,x2,uv) * vec4(0,1,7,1);\n\tcol += scanLine(x2,x3,uv) * vec4(0,1,1,1);\n\tcol += scanLine(x3,x0,uv) * vec4(1,1,9,1);\n\n        col.rgb += mix(vec3(0.0),vec3(0.0),uv.y)*sign(0.0-col.a);\n\n\tgl_FragColor = vec4( col.rgb, 91.0 );\n}\n", "user": "a70cbe4", "parent": "/e#21585.0", "id": "21593.5"}