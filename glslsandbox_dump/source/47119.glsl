{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nconst int Iterations = 320;\nconst float CollisionThreshold = 0.001;\n\nfloat distSphere(float radius, vec3 p) { return length(p) - radius; }\nfloat distBox(vec3 size, vec3 p) { return length(max(abs(p) - size, vec3(0))); }\nvec3 boxNormal(vec3 size, vec3 p, float d)\n{\n\tfloat xd = distBox(size, p + vec3(0.0001, 0, 0)) - d;\n\tfloat yd = distBox(size, p + vec3(0, 0.0001, 0)) - d;\n\tfloat zd = distBox(size, p + vec3(0, 0, 0.0001)) - d;\n\treturn normalize(vec3(xd, yd, zd));\n}\n\nvec3 foldx(vec3 i) { i.x = abs(i.x); return i; }\nmat2 rmat(float deg)\n{\n\tfloat s = sin(deg), c = cos(deg);\n\treturn mat2(c, s, -s, c);\n}\n\nfloat distRoundBoxes(vec3 p)\n{\n\tfloat d = distBox(vec3(1.0, 0.1, 100), p);\n\tfor(int i = 0; i < 4; i++)\n\t{\n\t\tp.y = mod(-p.y, 1.6); p -= vec3(-3, 0, 0); p.x = -abs(p.x); p.xy *= rmat(0.15);\n\t\td = min(d, distBox(vec3(1.0, 0.5, 100), p));\n\t}\n\treturn d;\n}\n\nstruct MinDistanceSurfaceInfo { float d; vec3 normal; };\nMinDistanceSurfaceInfo detectNearest(vec3 p)\n{\n\tMinDistanceSurfaceInfo ms;\n\tfloat d = distSphere(0.6, foldx(p) - vec3(0.5, 0, 10));\n\tms.d = d; ms.normal = normalize(foldx(p) - vec3(0.5, 0, 10));\n\t\n\td = distRoundBoxes(p);\n\tif(d < ms.d) { ms.d = d; }\n\treturn ms;\n}\n\nvoid main( void )\n{\n\tvec3 pos = vec3(0, 0, -2);\n\tvec3 ray = normalize(vec3(vec2(resolution.x / resolution.y, 1.0) * (gl_FragCoord.xy / resolution.xy - 0.5), 0) - pos);\n\tray.xy *= rmat(0.3 * time);\n\tpos.z -= time * 0.3 / 50.0;\n\t\n\tfor(int n = 0; n < Iterations; n++)\n\t{\n\t\tMinDistanceSurfaceInfo ms = detectNearest(pos);\n\t\tif(ms.d <= CollisionThreshold)\n\t\t{\n\t\t\tgl_FragColor = vec4(vec3(float(n) / 35.0) * vec3(0.75, 0.75, 1.0)/* * ms.normal*/, 1);\n\t\t\treturn;\n\t\t}\n\t\tpos += ray * ms.d;\n\t}\n\tgl_FragColor = vec4(0);\n\n}", "user": "20c9047", "parent": null, "id": 47119}