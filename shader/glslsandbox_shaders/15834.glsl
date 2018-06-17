{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nint siBinar(int a,int b) {\n\tif (b < 0) return -1;\n\tif (a < 0) a += 16384;\n\n\tint result = 0;\n\n\tint produs = 1;\n\n\t\n\tfor (int i = 0;i < 16;i++) {\n\t\tresult += int(mod(float(a),2.0)*mod(float(b),2.0))*produs;\n\n\t\tprodus *= 2;\n\n\t\ta /= 2;\n\t\tb /= 2;\n\t}\n\n\treturn result;\n}\n\nvoid main( void ) {\n\n\tvec2 position = gl_FragCoord.xy-resolution*.5;\n\tfloat t = time*.1;\n\t//position += sin(position.yx*.1*sin(time*.5))*10.*.5;\n\tposition *= mat2(cos(t),-sin(t),sin(t),cos(t));\n\tposition.y *= 2./sqrt(3.);\n\tposition.x -= position.y*.5;\n\t\n\tposition *= pow(2.,1.-fract(time));\n\t\n\tfloat color = 0.0;\n\n\tint bin = siBinar(int(floor(position.x)),int(floor(position.y)));\n\tif (bin == 0) {\n\t\tcolor = 1.0;\n\t} else if (bin == 1) {\n\t\tcolor = 1.-fract(time);\n\t} \n\tgl_FragColor = vec4( color,color,color, 1.0 );\n\n}", "user": "b9b84f", "parent": "/e#15833.0", "id": "15834.1"}