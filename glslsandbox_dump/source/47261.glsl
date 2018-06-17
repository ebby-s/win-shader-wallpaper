{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n\n\tvec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;\n\n\tvec3 color = vec3(0.0);\n\t\n\tcolor.r = (cos(time*100.)+1.)/2.;\n\tcolor.g = (sin(time*100.)+1.)/2.;\n\tcolor.b = (sin(time*100.)+1.)/2.;\n\n\tgl_FragColor = vec4( color, 1.0 );\n\n}", "user": "5d59050", "parent": null, "id": 47261}