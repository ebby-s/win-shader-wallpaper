{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main() {\n  vec4 o = gl_FragColor;\n  vec2 i = gl_FragCoord.xy;\t\t\n  float c = time/0.5;\n  o-=o; i/=18.; \n\n  float x=i.x;\n  for (int n=0; n<1; n++) {\n     x-=3.; \n       if (x<3.&&x>0.) {\n       int j = int(i.y);\n       //j = ( x<0.? 0:\n       //      j==5? 972980223: j==4? 690407533: j==3? 704642687: j==2? 696556137:j==1? 972881535: 0 \n       //    ) / int(pow(2.,floor(30.-x-mod(floor(c),10.)*3.)));\n\t       \n\t/////////////////////////////////////////////////////////////////////////\n\t//can anybody tell me why here is 972980223 and 690407533,why?  thanks!//\n\t/////////////////////////////////////////////////////////////////////////\n       j = ( x<0.? 0:\n             j==5? 972980223: j==4? 690407533: j==3? 704642687: j==2? 696556137:j==1? 972881535: 0 \n           )/int(pow(2.,\n                        floor(30.-x-mod(floor(c),10.)*3.))); \n\t       \n\t       \n       //j = int(i.y);\n       //j = (j==5?9:j==4?0:j==3?0:j==2?0:j==1?0:1) /int(pow(2., 2.-x-0.));\n       //j = (j == 5 && x == 1. ? 1 : 0);\n\t       \n\t       \n       o = vec4(j - j / 2 * 2);\n       break;\n    }\n    c/=1.0;\n  }\n\tgl_FragColor = o;\n}", "user": "30b3530", "parent": null, "id": 47093}