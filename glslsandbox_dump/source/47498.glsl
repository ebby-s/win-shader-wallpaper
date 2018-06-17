{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 resolution;\n\nfloat scene(vec3 p) {\n\tfloat d = length(p * (1. / vec3(1., 1., 100))) - .1;\n\treturn d;\n}\t\n\nvec3 repeat(vec3 v) { vec3 r = vec3(2.); return mod(v + r / 2., r) - r / 2.; }\nvoid main() {\n\tvec2 st = (2. * gl_FragCoord.xy - resolution) / resolution.y;\n\tfloat t = 0.;\n\tfor (int i = 0; i < 32; i++) \n\t\tt += .5 * (scene(\n\t\t\trepeat(vec3(2. * time, 2. * time, time) +\n\t\t\tvec3(st, 2.) * t)\n\t\t));\n\tgl_FragColor = vec4(vec3(1. / t), 1.);\t\n}", "user": "ed23b80", "parent": null, "id": 47498}