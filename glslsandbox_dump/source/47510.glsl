{"code": "#ifdef GL_ES\nprecision  mediump float;\n#endif\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 resolution;\nuniform vec2 mouse;\n\nvec2 rotate(in vec2 v, in float a) {\n\treturn vec2(cos(a)*v.x + sin(a)*v.x, -sin(a)*v.y -cos(a)*v.y);\n}\n\nfloat torus(in vec3 p, in vec2 t)\n{\n\tvec2 q = abs(vec2(max(abs(p.x), abs(p.z))-t.x, p.y/mouse.x));\n\treturn max(q.x, q.y)/t.y;\n}\n\nfloat trap(in vec3 p)\n{\n\treturn abs(min(abs(p.z)-0.1, abs(p.x)-0.5))-0.002;\n\t//return length(max(abs(p.xy) - 0.05, 0.0));j\n\treturn length(max(abs(p) - 0.35, 0.0));\n\treturn abs(length(p.xz)-0.2)-0.03*mouse.x;\n\treturn min(length(p.xz), min(length(p.yz), length(p.xy))) - 0.05*mouse.y;\n\treturn abs(min(torus(vec3(p.x, mod(p.y,0.4)-0.2, p.z), vec2(0.1, 0.05)), max(abs(p.z)-(0.06), abs(p.x)-0.054)))-0.005;\n\treturn abs(min(torus(p, vec2(0.3, 0.05)), max(abs(p.z)-0.05, abs(p.x)-0.05)))-0.005;\n}\n\nfloat map(in vec3 p)\n{\n    float time2 = time+60.0*sin(mouse.y/3.);\n\tfloat cutout = dot(abs(p.yz),vec2(1.3*fract(time*mouse.x+0.5)))-0.035;\n  float road = max(abs(p.y-0.025), abs(p.z)-0.035);\n\t\n\tvec3 z = abs(2.0-mod(p,1.0));\n\tz.yz = rotate(z.yz, time2*0.05);\n\n\tfloat d = 999.0;\n\tfloat s = 1.0;\n\tfor (float i = 0.0; i < 3.0; i++) {\n\t\tz.xz = rotate(z.xz, radians(i*5.+time2));\n\t\tz.zy = rotate(z.yz, radians((i+1.0)*20.0+time2*1.1234));\n\t\tz = abs(1.0-mod(z+i/3.0,2.0));\n\t\t\n\t\tz = z*2.0 - 0.3;\n\t\ts *= 0.5;\n\t\td = min(d, trap(z) * s);\n  \t}\n\treturn max(d, -cutout);\n}\n\nvec3 hsv(in float h, in float s, in float v) {\n\treturn mix(vec3(1.0), clamp((abs(fract(h + vec3(3, 2, 1) / 3.0) * 6.0 - 3.0) - 1.0), 0.0 , 1.0), s) * v;\n}\n\nvec3 intersect(in vec3 rayOrigin, in vec3 rayDir)\n{\n    float time2 = time+60.0;\n\tfloat total_dist = 0.0;\n\tvec3 p = rayOrigin;\n\tfloat d = 1.0;\n\tfloat iter = 0.0;\n\tfloat mind = 3.14159+sin(time2*0.20)*0.0; // Move road fyrom side to side slowly\n\t\n\tfor (int i = 0; i < 59; i++)\n\t{\t\t\n\t\tif (d < 0.001) continue;\n\t\t\n\t\td = map(p);\n\t\t// This rotation causes the occasional distortion - like you would see from heat waves\n\t\tp += d*vec3(rayDir.x, rotate(rayDir.yz, sin(-mind))*6.);\n\t\tmind = min(mind, d);\n\t\ttotal_dist += d;\n\t\titer++;\n\t}\n\n\tvec3 color = vec3(0.0);\n\tif (d < 0.001) {\n\t\tfloat x = (iter/35.0);\n\t\tfloat y = (d-00.01)/0.01/(59.0);\n\t\tfloat z = (0.01-d)/0.1/59.0;\n\t\t\n\n\t\t\tfloat q = 1.0-x-y*3.+z;\n\t\t\tcolor = hsv(q*0.9+0.9, 1.0*q*0.2, q);\n\t} \n\t\t//color = hsv(d, 1.0, 1.0)*mind*45.0; // Background\n\treturn color;\n}\n\nvoid main( void )\n{\n    float time2 = time+60.0;\n\tvec3 upDirection = vec3(0, -1, 0);\n\tvec3 cameraDir = vec3(1,0,0);\n\tvec3 cameraOrigin = vec3(time2*0.1, 0, 0);\n\t\n\tvec3 u = normalize(cross(upDirection, cameraOrigin));\n\tvec3 v = normalize(cross(cameraDir, u));\n\tvec2 screenPos = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;\n\tscreenPos.x *= resolution.x / resolution.y;\n\tvec3 rayDir = normalize(u * screenPos.x + v * screenPos.y + cameraDir*(1.0-length(screenPos)*0.5));\n\tvec3 col = vec3( intersect(cameraOrigin, rayDir) );\n\tgl_FragColor = vec4(col,1.0);\n} ", "user": "9fd34c9", "parent": "/e#47509.0", "id": 47510}