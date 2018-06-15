{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n\n\tvec2 position = ( gl_FragCoord.xy -  resolution.xy*.5 ) / resolution.x;\n\n\t// 256 angle steps\n\tfloat angle = atan(position.y,position.x)/(2.*3.14159265359);\n\tangle -= floor(angle);\n\tfloat rad = length(position);\n\t\n\tfloat color = 0.0;\n\tfor (int i = 0; i < 10; i++) {\n\t\tfloat angleFract = fract(angle*256.);\n\t\tfloat angleRnd = floor(angle*256.)+123423.;\n\t\tfloat angleRnd1 = fract(angleRnd*fract(angleRnd*.7235)*45.1);\n\t\tfloat angleRnd2 = fract(angleRnd*fract(angleRnd*.82657)*13.724);\n\t\tfloat t = time+angleRnd1*10.;\n\t\tfloat radDist = sqrt(angleRnd2+float(i));\n\t\t\n\t\tfloat adist = radDist/rad*.1;\n\t\tfloat dist = (t*.1+adist);\n\t\tdist = abs(fract(dist)-.5);\n\t\tcolor += max(0.,.5-dist*40./adist)*(.5-abs(angleFract-.5))*5./adist/radDist;\n\t\t\n\t\tangle = fract(angle+.61);\n\t}\n\n\tgl_FragColor = vec4( color )*.3;\n\n}", "user": "1616010", "parent": "/e#5334.3", "id": "28063.0"}