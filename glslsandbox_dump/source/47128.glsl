{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n\t\n\tvec2 center = resolution.xy / 2.0;\n\tvec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;\n\tvec2 d = center.xy - position.xy;\n\n\tfloat dist = sqrt((d.x * d.x) + (d.y * d.y));\n\n\tgl_FragColor = vec4( vec3( dist, dist, dist ), 1.0 );\n\n}", "user": "2096506", "parent": null, "id": 47128}