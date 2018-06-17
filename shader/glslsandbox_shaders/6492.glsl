{"code": "// A terrain julia set raymarcher by Kabuto\n\n#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nconst vec2 CONSTANT =  vec2(-0.835,-0.2321);\t// The mandelbrot set point for which to generate the julia set.\n//const vec2 CONSTANT = vec2(-0.70176,-0.3842);\n//const vec2 CONSTANT = vec2(-0.74543,+0.11301);\nconst int MAXITER = 50;\nconst int LOWITER = 10;\nconst int MAXTRACE = 150;\nconst float MAXDEPTH = 100.;\n\n// Distance function. Warning: generates bugs for CONSTANT outside the mandelbrot set's features (so the resulting julia set consists of unconnected dots)\nfloat iter(vec4 p, vec4 n4) {\n\tfor(int i=0; i<MAXITER; i++) {\n\t\tp = p*p.x*vec4(1,1,2,2)+p.yxwz*p.y*vec4(-1,1,-2,2)+n4;\n\t\tp = p*p.x*vec4(1,1,2,2)+p.yxwz*p.y*vec4(-1,1,-2,2)+n4;\n\t\tp = p*p.x*vec4(1,1,2,2)+p.yxwz*p.y*vec4(-1,1,-2,2)+n4;\n\t\tp = p*p.x*vec4(1,1,2,2)+p.yxwz*p.y*vec4(-1,1,-2,2)+n4;\n\t\tif (dot(p.xy,p.xy) > 64.) break;\n\t}\n\tfloat l = length(p.xy);\n\tfloat dl = length(p.zw);\n\treturn l<4. ? 0. : l*log(l)/dl;\n}\n\n\nvoid main( void ) {\n\tvec2 n = (gl_FragCoord.xy-resolution*.5)/resolution.x;\n\t\n\t\n\t// Iterating over the isosurface\n\tvec4 n4 = vec4(CONSTANT,0,0);\n\tfloat amplify = 1.5; // how much to amplify height\n\tfloat t = time*.5;\n\tvec2 pos2 = vec2(cos(t)*.9,sin(t)*.9001);\t// Warning: AMD compiler shader bug lingering in here. Specifying the same factor for both (or the entire vec2) will make it fail.\n\tvec3 pos = vec3(pos2,-cos(2.*t)*.05+.5)-vec3(0,0,.3);\t// Another nasty workaround for another nasty AMD shader compiler bug.\n\tvec3 dir = normalize(-pos*vec3(1,1,.7)+vec3(0,0,-.1));\n\tvec3 right = normalize(cross(dir, vec3(0,0,1)));\n\tvec3 up = cross(dir,right);\n\tvec3 ray = normalize(dir+right*n.x-up*n.y);\n\t\n\tfloat factor = 1./(amplify-ray.z/length(ray.xy)); // correction factor for step distance\n\t\n\tfloat m = 0.;\n\tfloat md = 0.;\n\t\n\tfloat steps = float(MAXTRACE);\n\tfor (int i = 0; i < MAXTRACE; i++) {\n\t\tm = iter(vec4(pos.xy,1,0),n4)*amplify;\n\t\tfloat cutoff = .1;\n\t\tm = (1.-1./(1.+m/cutoff))*cutoff;\n\t\tmd = pos.z-m;\n\t\tif (md < 1e-4)  {steps = float(i); break;}\n\t\tpos += ray*md*factor;\n\t}\n\t\t\n\n\tvec3 cb = vec3(30.,4,1)*.001;\n\tvec3 color = cb/(cb+sqrt(m));\n\t\n\tgl_FragColor = vec4(color+vec3(2.,.3,.0)*(1.-sqrt((float(MAXTRACE)-steps)/float(MAXTRACE))), 1.0 );\n\n}", "user": "15d3ae3", "parent": "/e#6480.4", "id": "6492.0"}