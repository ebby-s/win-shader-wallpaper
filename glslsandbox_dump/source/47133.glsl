{"code": "// work in progress, made by dr1ft\n// only saving so i can show my friends :)\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 resolution;\n\nconst float max_depth = 12.0;\n\nvec2 waver(float x){\n\treturn vec2(cos(x),sin(x))*0.15;\n}\n\nfloat checkerboard (vec2 offset, float depth){\n\tdepth = mod(depth,max_depth)*3.0;\n\tvec2 position = (gl_FragCoord.xy / vec2(resolution.x) - vec2(0.5,0.25)) * vec2(depth) + offset;\n\tposition += waver(depth*0.15+time*1.4);\n\treturn clamp(sign((mod(position.x, 1.0) - 0.5) * (mod(position.y, 1.0) - 0.5)) / depth * 2.0,0.0,1.0);\n}\n\nvoid main( void ) {\n\t\n\tfloat color = 0.0;\n\tfor (float i = 0.0; i < max_depth; i++){\n\t\tfloat n=checkerboard(vec2(0.25,0.75), i-time*1.0);\n\t\tif (n>color){\n\t\t\tcolor=n;\n\t\t}\n\t}\n\tcolor*=0.8;\n\n\tgl_FragColor = vec4(vec3(0.0,color,color),1.0);\n\n}", "user": "3a41b3c", "parent": null, "id": 47133}