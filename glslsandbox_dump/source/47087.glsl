{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform vec2 resolution;\nvarying vec2 surfacePosition;\n\nvoid main( void ) {\n\t\n\tvec2 pos = vec2(0.0);\n\t\n\tfloat dist = distance(surfacePosition , vec2(0));\n\t\n\tgl_FragColor = vec4( vec3( 1.0 - dist,0 ,0 ),1.0);\n}", "user": "2a1199e", "parent": "/e#46968.0", "id": 47087}