{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n/*\n * inspired by http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/\n * a slight(?) different \n * public domain\n */\n\n#define N 20\nvoid main( void ) {\n\tvec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 20.0;\n\n\tfloat rsum = 0.0;\n\tfloat pi2 = 3.1415926535 * 2.0;\n\tfloat C = asin(sin(time / 20.));\n\tfloat S = acos(cos(time / 20.));\n\tvec2 shift = vec2( 0.2, 1.0 );\n\tfloat zoom = (0.*1.0 + 1.0);\n\t\n\tfor ( int i = 0; i < N; i++ ){\n\t\tfloat rr = v.x*v.x+v.y*v.y;\n\t\tif ( rr > 1.0 ){\n\t\t\trr = 1.0/rr;\n\t\t\tv.x = v.x * rr;\n\t\t\tv.y = v.y * rr;\n\t\t}\n\t\trsum *= 0.99;\n\t\trsum += rr;\n\t\t\n\t\tv = vec2( C*v.x-S*v.y, S*v.x+C*v.y ) * zoom + shift;\n\t}\n\t\n\tfloat col = rsum * 0.5;\n\n\n\tgl_FragColor = vec4( cos(col*1.0), cos(col*2.0), cos(col*4.0), 1.0 );\n\n}", "user": "2188528", "parent": "/e#46712.0", "id": 47149}