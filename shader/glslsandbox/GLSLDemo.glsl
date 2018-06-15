{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n//Testing letters made from arcs and quads.\n\nfloat dfSemiArc(float rma, float rmi, vec2 uv)\n{\n\treturn max(abs(length(uv) - rma) - rmi, uv.x-0.0);\n}\n\nfloat dfQuad(vec2 p0, vec2 p1, vec2 p2, vec2 p3, vec2 uv)\n{\n\tvec2 s0n = normalize((p1 - p0).yx * vec2(-1,1));\n\tvec2 s1n = normalize((p2 - p1).yx * vec2(-1,1));\n\tvec2 s2n = normalize((p3 - p2).yx * vec2(-1,1));\n\tvec2 s3n = normalize((p0 - p3).yx * vec2(-1,1));\n\t\n\treturn max(max(dot(uv-p0,s0n),dot(uv-p1,s1n)), max(dot(uv-p2,s2n),dot(uv-p3,s3n)));\n}\n\nfloat dfRect(vec2 size, vec2 uv)\n{\n\treturn max(max(-uv.x,uv.x - size.x),max(-uv.y,uv.y - size.t));\n}\n\n//--- Letters ---\nvoid G(inout float df, vec2 uv)\n{\n\t\n\tdf = min(df, dfSemiArc(0.5, 0.125, uv));\n\tdf = min(df, dfQuad(vec2(0.000, 0.375), vec2(0.000, 0.625), vec2(0.250, 0.625), vec2(0.125, 0.375), uv));\n\tdf = min(df, dfRect(vec2(0.250, 0.50), uv - vec2(0.0,-0.625)));\n\tdf = min(df, dfQuad(vec2(-0.250,-0.125), vec2(-0.125,0.125), vec2(0.250,0.125), vec2(0.250,-0.125), uv));\t\n}\n\nvoid L(inout float df, vec2 uv)\n{\n\tdf = min(df, dfRect(vec2(0.250, 1.25), uv - vec2(-0.625,-0.625)));\n\tdf = min(df, dfQuad(vec2(-0.375,-0.625), vec2(-0.375,-0.375), vec2(0.250,-0.375), vec2(0.125,-0.625), uv));\t\n}\n\nvoid S(inout float df, vec2 uv)\n{\n\tdf = min(df, dfSemiArc(0.25, 0.125, uv - vec2(-0.250,0.250)));\n\tdf = min(df, dfSemiArc(0.25, 0.125, (uv - vec2(-0.125,-0.25)) * vec2(-1)));\n\tdf = min(df, dfRect(vec2(0.125, 0.250), uv - vec2(-0.250,-0.125)));\n\tdf = min(df, dfQuad(vec2(-0.625,-0.625), vec2(-0.500,-0.375), vec2(-0.125,-0.375), vec2(-0.125,-0.625), uv));\t\n\tdf = min(df, dfQuad(vec2(-0.250,0.375), vec2(-0.250,0.625), vec2(0.250,0.625), vec2(0.125,0.375), uv));\n}\n//----------------------\nfloat linstep(float x0, float x1, float xn)\n{\n\treturn (xn - x0) / (x1 - x0);\n}\n//----------------------\nvec3 retrograd(float x0, float x1, vec2 uv)\n{\n\tfloat mid = -0.2;// + sin(uv.x*24.0)*0.01;\n\n\tvec3 grad1 = mix(vec3(0.60, 0.90, 1.00), vec3(0.05, 0.05, 0.40), linstep(mid, x1, uv.y));\n\tvec3 grad2 = mix(vec3(1.90, 1.30, 1.00), vec3(0.10, 0.10, 0.00), linstep(x0, mid, uv.y));\n\n\treturn mix(grad2, grad1, smoothstep(mid, mid + 0.008, uv.y));\n}\n//----------------------\nconst vec3 color1 = vec3(-1., 0., 0.9);\nconst vec3 color2 = vec3(0.9, 0., 0.9);\n\nfloat cdist(vec2 v0, vec2 v1)\n{\n  v0 = abs(v0 - v1);\n  return max(v0.x, v0.y);\n}\n\nvec3 gridColor()\n{\n  vec2 uv = gl_FragCoord.xy / resolution.y;\n  vec2 cen = resolution.xy / resolution.y / 2.;\n  vec2 gruv = uv - cen;\n  gruv = vec2(gruv.x * abs(1./gruv.y), abs(1./gruv.y));\n  gruv.y += time;\n  gruv.x += 0.5*sin(time);\n\n  float grid = 2. * cdist(vec2(0.5), mod(gruv,vec2(1.)));\n\t\t\n  float gridmix = max(pow(grid,6.), smoothstep(0.93,0.96,grid) * 2.);\n\n  vec3 gridcol = (mix(color1, color2, uv.y*2.) + 1.2) * gridmix;\n  gridcol *= linstep(0.1, 2.0, abs(uv.y - cen.y));\n  return gridcol;\n}\n//----------------------\nvoid main( void ) \n{\n\tvec2 uv = gl_FragCoord.xy / resolution.y;\n\tvec2 aspect = resolution.xy / resolution.y;\n\t\n\tuv = (uv - aspect/2.0)*4.0;\n\n\tfloat dist = 1e6;\n\tfloat charSpace = 1.125;\n\t\n\tvec2 chuv = uv;\n\tchuv.x += charSpace * 1.5;\n\t\t\n\tG(dist, chuv); chuv.x -= charSpace;\n\tL(dist, chuv); chuv.x -= charSpace;\n\tS(dist, chuv); chuv.x -= charSpace;\n\tL(dist, chuv); chuv.x -= charSpace;\n\t\n\tfloat mask = smoothstep(4.0 / resolution.y, 0.0, dist);\n\t\n\tvec3 backcol = gridColor();\n\n\tvec3 textcol = retrograd(-0.75,0.50,uv + vec2(0.0,-pow(max(0.0,-dist*0.1),0.5)*0.2));\n\t\n\tvec3 color = mix(backcol,textcol,mask);\n\t\n\tgl_FragColor = vec4( vec3( color ), 1.0 );\n}", "user": "e6655f7", "parent": "/e#26936.6", "id": "27028.0"}