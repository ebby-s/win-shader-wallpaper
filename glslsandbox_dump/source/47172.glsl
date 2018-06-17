{"code": "// nikitpad, 2018\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main(void) \n{\n\tvec2 texCoord = (gl_FragCoord.xy / resolution.xy);\n\ttexCoord +=  sin(texCoord.x * 6. + time) * 0.1;\n\tif (texCoord.y > 0.0)\n\t\tgl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);\n\tif (texCoord.y > 0.3)\n\t\tgl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);\n\tif (texCoord.y > 0.7)\n\t\tgl_FragColor = vec4(1.0);\n\tif (texCoord.y > 1.0)\n\t\tgl_FragColor = vec4(0.0);\n\t\n}", "user": "350f292", "parent": "/e#46993.2", "id": 47172}