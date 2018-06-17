{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nint packFloat(inout float f, int off){\n    int o = 0;\n    \n    for (int i = 0; i < 8; i++){\n        float mul = 1. / exp2(float(i + off + 1));\n        \n        if (f >= mul){\n            f -= mul;\n            \n            o += int(exp2(float(i)));\n        }\n    }\n    \n    return o;\n}\n\nvec4 packFloat4(float f){\n    return vec4(\n        float(packFloat(f,  0)) / 255.,\n        float(packFloat(f,  8)) / 255.,\n        float(packFloat(f, 16)) / 255.,\n        float(packFloat(f, 24)) / 255.\n    );\n}\n\nfloat unpackFloat(int f, int off){\n        float o = 0.;\n        \n        for (int i = 0; i < 8; i++){\n            if (bool(mod(floor(float(f) / exp2(float(i))), 2.))){\n                o += 1. / exp2(float(i + off + 1));\n            }\n        }\n        \n        return o;\n    }\n\n    float unpackFloat4(vec4 value){\n        return\n            unpackFloat(int(value.x * 255.),  0) + \n            unpackFloat(int(value.y * 255.),  8) + \n            unpackFloat(int(value.z * 255.), 16) + \n            unpackFloat(int(value.w * 255.), 24);\n    }\n\nvoid main( void ) {\n\tvec3 color;\n\tfloat y = gl_FragCoord.y / resolution.y;\n\t\n\t//our value to compress\n\tfloat value = fract(gl_FragCoord.x / 100. + time) / 2. + .5;\n\tfloat bit8 = floor(value * 255.) / 255.;\n\t\n\tvec4 pack = packFloat4(value);\n\tvec4 pack8 = floor(pack * 255.) / 255.;\n\t\n\tif (y > 0.9){ // output the value as a control\n\t\tcolor = vec3(value);\n\t}else if (y > 0.8){ // 8 bit precision\n\t\t//since everybody here is watching this on a 8bit precision monitor you would\n\t\t//not be able to tell the difference. So I am going to render the difference\n\t\t//between the source and the destination and multiply that by 1000 so you can\n\t\t//see the difference.\n\t\t\n\t\tcolor = vec3(abs(bit8 - value) * 1000.);\t\n\t}else if (y > 0.2){\n\t\t//output the packed vec4 because it makes a seizure inducing visual.\n\t\tcolor = pack.xyz;\n\t}else{\n\t\t//unpack the value and display the difference multiplied by 1000 (which there is none)\n\t\t\n\t\tfloat unpack = unpackFloat4(pack8);\n\t\t\n\t\tcolor = vec3(abs(unpack - value) * 1000.);\n\t}\n\t\n\tgl_FragColor = vec4(color, 1);\n}", "user": "ff8d18c", "parent": "/e#33805.0", "id": 47022}