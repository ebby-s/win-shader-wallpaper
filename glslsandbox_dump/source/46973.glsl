{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n\n\tvec2 position = ( gl_FragCoord.xy / resolution.xy );\n\n\tfloat d = 1.0/5.0;\n\tfloat r = position.y > d*1.0 &&  position.y < d*4.0 ? 1.0 : 0.0;\n\tfloat g = position.y > d*2.0 && position.y < d*3.0 ? 1.0 : 0.0;\n\n\tgl_FragColor = vec4( vec3(r,g,1), 1.0 );\n\n}", "user": "3a41b3c", "parent": null, "id": 46973}