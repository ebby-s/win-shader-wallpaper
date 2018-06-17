{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\nvarying vec2 surfacePosition;\nuniform vec2 surfaceSize;\n\n// https://math.stackexchange.com/questions/2654984/identifying-this-chaotic-recurrence-relation\n\n#define N 500.0\n\nvoid main( void ) {\n\t\n\tgl_FragColor = vec4( 1.0 );\n\t\n\tfloat rho = 5./max(resolution.x, resolution.y);\n\t\n\tvec2 k = 8.*(mouse-.5);\n\tvec2 xy = vec2(sin(time*80.),cos(time*93.));\n\tvec2 sp = 2.5*surfacePosition;\n\t\n\tif(max(abs(sp.x), abs(sp.y)) > 1.){\n\t\tgl_FragColor = vec4(0.5);\t\n\t}\n\telse\n\t\tgl_FragColor = vec4(0.);\n\t\n\tfloat c = 0.;\n\tfor(float i = 0.; i <= N; i += 1.){\n\t\tvec2 v = sp-xy;\n\t\tfloat r = .1/dot(v,v);\n\t\tif( i > N/10. ) c += r*r;\n\t\txy = vec2(sin( k.x * (xy.x+xy.y) ), sin( k.y * (xy.y - xy.x) ));\n\t}\n\tc /= N*N;\n\tgl_FragColor += vec4(c*.01,c*.1,c,0.);\n}", "user": "9c059e3", "parent": "/e#47052.4", "id": 47158}