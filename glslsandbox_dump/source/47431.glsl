{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nconst float nr = 5.0;\n\nvoid main( void ) {\n\n\tvec2 position = ( gl_FragCoord.xy / resolution.xy );\n\n\tvec3 color = vec3(0.0);\n\t\n\tfor(float i = 0.0;i<nr;i+=1.)\n\t{\n\t\tcolor.r += 0.1/(abs(((sin(position.x+time+i)+1.)*0.5)-position.y)*nr);\n\t\tcolor.g += 0.1/(abs(((sin(position.x+time+i+1.0)+1.)*0.5)-position.y)*nr);\n\t\tcolor.b += 0.1/(abs(((sin(position.x+time+i+2.0)+1.)*0.5)-position.y)*nr);\n\t}\n\t\n\n\tgl_FragColor = vec4( color, 1.0 );\n\n}", "user": "8b3d3e4", "parent": null, "id": 47431}