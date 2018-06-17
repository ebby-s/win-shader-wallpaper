{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\n#define QUALITY 1024.0\nvarying vec2 surfacePosition;\nfloat zoom=1.0;\nfloat xMove=0.0;\nfloat yMove=0.0;\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n//manages the coloring scheme\nvec3 hsv2rgb(vec3 c) {\n\tvec4 K = vec4(1., 2.0 / 3.0, 1.0 / 3.0, 3.0);\n\tvec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);\n\treturn c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);\n}\n//part of the equation for the mandelbrotset\nvec2 csq(vec2 z1) {\n\treturn vec2(z1.x*z1.x-z1.y*z1.y+z1.x, 2.0*z1.x*z1.y+z1.y);\n}\n\nvec3 mandel(vec2 p) {\n\tvec2 s = vec2(0);\n\t// how many iterations the program does\n\tfor (int i = 0; i < int(QUALITY); ++i) {\n\t\t//equation for the medelbrot set\n\t\ts = csq(s*(1./zoom))+p;\n\t\t//cuts it off at a certain size \n\t\tif (length(s) > 10.5) {\n\t\t\treturn hsv2rgb(vec3((float(i)/QUALITY), 1., 1.));\n\t\t}\n\t}\n\treturn vec3(0.0);\n}\n\nvoid main( void ) {\n\tvec2 p;\n\tp = vec2(surfacePosition.x+0.,surfacePosition.y-sqrt(-1.));\n\tvec3 color = mandel(p);\n\t// vec3 color = hsv2rgb(vec3(sin(iter * 1.4 + time), 0.9, 0.8));\n\n\tgl_FragColor = vec4(color * vec3(1.0,1.4,0.8), 1.0);\n\n}", "user": "9f5b321", "parent": "/e#46835.4", "id": 47025}