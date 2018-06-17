{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nconst float PHI = sqrt(5.0) * 0.5 + 0.5;\n\nvoid main( void ) {\n\n\tvec2 texcoord = gl_FragCoord.xy / resolution.xy;\n\t     //texcoord = vec2(0.5);\n\t\n\tvec3 color = normalize(vec3(texcoord.x * 2.0, texcoord.y * 2.0, (1.0 - texcoord.x) * 2.0)+1.0)-0.5;\n\t     color = sqrt(color);\n\t     color = normalize(color);\n\t     color = color * color;\n\t     color = clamp(color, 0.0, 1.0);\n\n\tgl_FragColor = vec4(color, 1.0 );\n\n}", "user": "171729c", "parent": null, "id": 47005}