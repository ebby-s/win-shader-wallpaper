{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) \n{\n\tvec2 pos = gl_FragCoord.xy;\n\tvec3 color = vec3(0, 0, 0);\n\t\n\tfloat speed = 1.0;\n\t\n\tfloat wave = (sin(time * speed) + 1.0) / 2.0 + (sin((pos.x / 20.0) + time * speed) + 1.0) / ((4.0 - ((sin(time) + 1.0) / 2.0 * 1.0)));\n\tif (pos.y < resolution.y * wave / 6.0 + resolution.y / 2.0 - 60.0) {\n\t\tcolor = vec3(0.1, 0.1, 0.4);\n\t}\n\tgl_FragColor = vec4(color, 1.0);\n}", "user": "8ab8e1c", "parent": null, "id": 46942}