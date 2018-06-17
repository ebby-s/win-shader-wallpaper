{"code": "/*\nEye of Sauron \n\nInspired by IQ\n\nZiad 2/6/2018\n\nColors can be improved\n*/\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nmat2 m =mat2(0.8,0.6, -0.6, 0.8);\n\nfloat rand(vec2 n) { \n\treturn fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);\n}\n\nfloat snoise(vec3 uv, float res)\n{\n\tconst vec3 s = vec3(1e0, 1e2, 1e3);\n\t\n\tuv *= res;\n\t\n\tvec3 uv0 = floor(mod(uv, res))*s;\n\tvec3 uv1 = floor(mod(uv+vec3(1.), res))*s;\n\t\n\tvec3 f = fract(uv); f = f*f*(3.0-2.0*f);\n\n\tvec4 v = vec4(uv0.x+uv0.y+uv0.z, uv1.x+uv0.y+uv0.z,\n\t\t      \t  uv0.x+uv1.y+uv0.z, uv1.x+uv1.y+uv0.z);\n\n\tvec4 r = fract(sin(v*1e-1)*1e3);\n\tfloat r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);\n\t\n\tr = fract(sin((v + uv1.z - uv0.z)*1e-1)*1e3);\n\tfloat r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);\n\t\n\treturn mix(r0, r1, f.z)*2.-1.;\n}\n\nfloat noise(vec2 n) {\n\tconst vec2 d = vec2(0.0, 1.0);\n  \tvec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));\n\treturn mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);\n}\n\nfloat fbm(vec2 p){\n\tfloat f=.0;\n\tf+= .5000*noise(p); p*= m*2.02;\n\tf+= .2500*noise(p); p*= m*2.03;\n\tf+= .1250*noise(p); p*= m*2.01;\n\tf+= .0625*noise(p); p*= m*2.04;\n\t\n\tf/= 0.9375;\n\t\n\treturn f;\n}\n\n\nvoid main( void ) {\n\tvec2 q = gl_FragCoord.xy/resolution.xy;\n\tvec2 p = -1.0+ 2.0*q;\n\tp.x *= resolution.x/resolution.y;\n\t\n\tvec3 background=smoothstep(.1,.5,vec3(.9,.4,.4));\n\tvec3 coord = vec3(sqrt((p.x)*(p.x)/(p.y+.8)/(.8-p.y))/6.2832+.5, length(p)*.4, .5);\n\tfor(int i=0;i<7;i++){\n\tfloat power = pow(2.0, float(i));\n\tbackground += vec3(0.001)- smoothstep(0.,1.34,(1.5 / power) * snoise(coord + vec3(0.,-time*.05, time*.01), power*16.));\n\t\n\t}\n\t\n\tfloat r = sqrt(dot(p,p));\n\tfloat a = atan(p.y,p.x);\n\tfloat e = sqrt((p.x)*(p.x)/(p.y+.8)/(.8-p.y) );\n\t\n\tfloat f = fbm(4.0*p);\n\t\n\tvec3 col = vec3(1.);\n\t\n\tfloat ss=.5+0.5*sin(3.*time);\n\tfloat anim =1. + 0.1*ss*clamp(1.-r,.0,1.);\n\tr*=anim;\n\t\n\tif( r<0.8){\n\t\t\n\t\tcol = vec3(.7,0.1,0.1);\n\t\t\n\t\tfloat f = 0.4*fbm(20.*p);\n\t\t\n\t\tcol = mix( col, vec3(0.5,0.4,0.3),f);\n\t\t\n\t\tf = 1.- smoothstep(0.1,0.5,e); \n\t\tcol = mix( col, vec3(1.,1.,0.39), f );\n\t\t\n\t\ta +=.05*fbm(20.0*p);\n\t\t\n\t\tf = smoothstep( 0.6, 1., fbm(vec2(5.0*e,50.0*a)));\n\t\tcol = mix(col, vec3 (1.0,.5,.5), f);\n\t\t\n\t\tf = smoothstep( .1, .9, fbm( vec2(10.*r,15.*a)));\n\t\tcol *= 1.- .5*f;\n\t\t\n\t\tf = smoothstep(0.6,0.8, r); \n\t\tcol*= .7 - .5*f;\n\t\t\n\t\tf = smoothstep(0.1,0.15, e); \n\t\tcol*= f;\n\t\t\n\t\tf = smoothstep(.5,.8, r);\n\t\tcol = mix( col,vec3(1.,.7,.39), f*.5);\n\t\t\n\t\tf= 1. - smoothstep( .001, .09, length( p- vec2(-0.05,0.3)));\n\t\tcol += vec3(1.)*f*0.4;\n\t\t\n\t\tf = smoothstep(.7,.8, r);\n\t\tcol = smoothstep(.01,.9, mix( col,vec3(2.), .4*f));\n\t\t\n\t\t\n\t}\n\tgl_FragColor=vec4(col*background, 1.);\n\n}", "user": "55b5624", "parent": "/e#47284.0", "id": 47293}