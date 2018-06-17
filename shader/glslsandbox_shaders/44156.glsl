{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 resolution;\n\n#define N(h) fract(sin(vec4(6,9,1,0)*h) * 9e2)\n\nvoid main(void) { \n\tvec4 o = vec4(0.);\n\tvec2 u = gl_FragCoord.xy/resolution.y;\n\n\tfloat e, d, i=0.;\n\tvec4 p;\n\n\tfor(float i=0.; i<9.; i++) {\n\t  d = floor(e = i*9.1+time);\n\t  p = N(d)+.3;\n\t  e -= d;\n\t  for(float d=0.; d<50.;d++)\n\t    o += p*(1.-e)/1e3/length(u-(p-e*(N(d*i)-.5)).xy);\n\t}\n\n\tif(u.y<N(ceil(u.x*10.+d+e)).x*.5)\n\t  o-=o*u.y;\n\tgl_FragColor = vec4(o.rgb, 1.);\n}", "user": "cb0994", "parent": null, "id": "44156.2"}