{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\n#define pi 3.14159265359\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n\t\n\tvec2 position = gl_FragCoord.xy / resolution;\n\t\n\tvec2 center = vec2(0.5, 0.5);\n\tfloat startAngle = mod(0.0, pi/2.0);\n\t\n\tvec2 direction = position - center;\n\t\n\tfloat angle = atan(-direction.y, -direction.x);\n    \tfloat linearLocation = fract((angle - time - pi) / (pi * 2.0));\n\tfloat location = smoothstep(0.0, 1.0, linearLocation);\n\n\tif (location <= 0.5) {\n\t\tgl_FragColor = vec4( mix(vec3(0.0, 0.0, 0.0), vec3(1.0, 0.0, 0.0), smoothstep(0.0, 0.5, location)), 1.0 );\n\t}\n\telse {\n\t\tgl_FragColor = vec4( mix(vec3(1.0, 0.0, 0.0), vec3(0.0, 0.0, 0.0), smoothstep(0.5, 1.0, location)), 1.0 );\t\n\t}\n\t\t\n\n}", "user": "9ae1125", "parent": null, "id": 47091}