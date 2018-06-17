{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\n//uniform vec2 resolution;\nvarying vec2 surfacePosition;\n\nvoid main(){\n\tvec2 pos = surfacePosition;\n\n\tconst float pi = 3.14159;\n\tconst int n = 13;\n\t\n\tfloat radius = length(pos)*4.0 - 1.3;\n\tfloat t = atan(pos.y, pos.x)/pi/2.0;\n\t\n\tfloat color = 0.0;\n\tfor (int i = 0; i < n; i++){\n\t\tcolor += 0.01/abs(0.7*cos(2.0*pi*(6.0 * t + float(i)/float(n) + 0.1 * time * (float(i)/float(n) - 0.5))) - radius);\n\t}\n\t\n\tgl_FragColor = vec4(vec3(1.5, 0.5, 0.15) * color, color);\n\t\n}", "user": "d0b7b1a", "parent": "/e#47340.0", "id": 47350}