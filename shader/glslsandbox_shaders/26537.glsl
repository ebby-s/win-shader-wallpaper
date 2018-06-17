{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#define RAD 5.\n#define LOOKUP 5.\n#define SPEED 2345.\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nfloat rand(vec2 co){\n    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);\n}\n\nbool shouldDraw(vec2 p) {\n\treturn rand(p / resolution.xy) * SPEED < time;\n}\n\n\nbool border(vec2 p1, vec2 c) {\n\tif (!shouldDraw(c))\n\t\treturn false;\n\treturn abs(abs(p1.x - c.x) + abs(p1.y - c.y) - RAD) < 1.;\n}\n\nfloat find() {\n\tfloat x = gl_FragCoord.x;\n\tfloat y = gl_FragCoord.y;\n\tbool running = true;\n\tfor (float i = -LOOKUP; i <= LOOKUP; ++i) {\n\t\tfor (float j = -LOOKUP; j <= LOOKUP; ++j) {\n\t\t\tfloat cx = x + i;\n\t\t\tfloat cy = y + j;\n\t\t\tif (cx < 0. || cy < 0. || cx > resolution.x || cy > resolution.y)\n\t\t\t\tcontinue;\n\t\t\tif (border(vec2(x, y), vec2(cx, cy)))\n\t\t\t\treturn 0.8;\t\t\t\t\n\n\t\t}\n\t}\n\treturn 0.;\n}\n\nvoid main( void ) {\n\tfloat color = find();\n\tgl_FragColor = vec4(0., 0., color, 1.);\n}\n\n/*\nvoid main4( void ) {\n\tfloat color = 0.;\t\n\tfloat x = gl_FragCoord.x;\n\tfloat y = gl_FragCoord.y;\n\n\tfor (float i = -RAD; i < RAD; ++i) {\n\t\tfor (float j = -RAD; j < RAD; ++j) {\n\t\t\tif (y + j < 0. || x + i < 0.)\n\t\t\t\tcontinue;\n\t\t\tif (!isCenter(vec2(x + i, y + j), vec2(0., 0.)))\n\t\t\t\tcontinue;\n\t\t\tif (border(vec2(x, y), vec2(x + i, y + j))) {\n\t\t\t    color = 1.;\n\t\t\t}\n\t\t}\n\t\n\t}\n\t\n\tgl_FragColor = vec4(color, 0., 0., 0.);\n}\n\n\n// Square\n\nvoid main( void ) {\n\tfloat color = 0.;\n\tfloat x = gl_FragCoord.x;\n\tfloat y = gl_FragCoord.y;\n\tfloat cx = RAD;\n\tfloat cy = RAD;\n\tif (border(vec2(x, y), vec2(cx, cy)))\n\t    color = 1.;\n\tgl_FragColor = vec4(color, 0., 0., 0.);\t\n}\n*/\n", "user": "7f365f3", "parent": null, "id": "26537.55"}