{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\nvarying vec2 surfacePosition;\nuniform vec2 surfaceSize;\n\n// https://math.stackexchange.com/questions/2654984/identifying-this-chaotic-recurrence-relation\n\nvoid main( void ) {\n\t\n\tgl_FragColor = vec4( 1.0 );\n\t\n\tfloat rho = 5./max(resolution.x, resolution.y);\n\t\n\tvec2 k = vec2(tan(time/30.)*3.14159*2.);\n\tvec2 xy = (mouse-.5)*2.;\n\tvec2 sp = 2.5*surfacePosition;\n\t\n\tif(max(abs(sp.x), abs(sp.y)) > 1.){\n\t\tgl_FragColor = vec4(0.5);\t\n\t}\n\t\n\tfor(float i = 0.; i <= 99.; i += 1.){\n\t\tif(max(abs(sp.x-xy.x), abs(sp.y-xy.y)) < rho) gl_FragColor = vec4(0);\n\t\txy = vec2(sin( k.x * (xy.x+xy.y) ), sin( k.y * (xy.y - xy.x) ));\n\t}\n\n}", "user": "ff8d18c", "parent": "/e#47052.4", "id": 47113}