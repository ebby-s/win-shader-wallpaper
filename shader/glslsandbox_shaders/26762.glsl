{"code": "// water turbulence effect by joltz0r 2013-07-04, improved 2013-07-07\n// Altered\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\nvarying vec2 surfacePosition;\n//vec2 surfacePosition = vec2 (104.,128.);\n#define MAX_ITER 8\nvoid main( void ) {\n\tvec2 p = surfacePosition*3.0- vec2(15.0);\n\tvec2 i = p;\n\tfloat c = 1.0;\n\tfloat inten = .05;\n\n\tfor (int n = 0; n < MAX_ITER; n++) \n\t{\n\t\tfloat t = time * (1.0 - (3.0 / float(n+1)));\n\t\ti = p + vec2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));\n\t\tc += 1.0/length(vec2(p.x / (2.*sin(i.x+t)/inten),p.y / (cos(i.y+t)/inten)));\n\t}\n\tc /= float(MAX_ITER);\n\tc = 1.5-sqrt(pow(c,3.+mouse.x*0.5));\n\tgl_FragColor = vec4(vec3(c*c*c*c*0.3,c*c*c*c*0.5,c*c*c*c*0.925), 1.0);\n\n}", "user": "408207e", "parent": "/e#12305.0", "id": "26762.0"}