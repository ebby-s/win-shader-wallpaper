{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\nvarying vec2 surfacePosition;\n\nvoid main( void ) {\n\n\tvec2 p = surfacePosition*3.;\n\t\n\tfloat a = atan(p.x,p.y);\n\tfloat r = length(p);\n\tfloat c = sin(time+r*20.0-cos(a*20.0*sin(r*3.14)));\n\tgl_FragColor = vec4(0.,c,0.,1.0);\n\n}", "user": "71ebf30", "parent": "/e#21162.0", "id": 47518}