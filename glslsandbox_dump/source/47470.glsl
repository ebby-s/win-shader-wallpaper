{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n\n//return the direction of ray\n//vec3 generate_camera_ray(position){}\n\nvoid main( void ) {\n\tvec2 position = (gl_FragCoord.xy * 2.0 - resolution);\t\n\t//ray = generate_camera_ray(position);\n\t//gl_FragColor = vec4(position.x/resolution.x, 0, -position.x/resolution.x, 1);\n}", "user": "319925c", "parent": null, "id": 47470}