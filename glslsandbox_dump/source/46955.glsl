{"code": "#ifdef GL_ES\nprecision highp float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\nconst int mx=1;\nconst float sc=100.0;\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\nuniform sampler2D backbuffer;\nfloat mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}\nvec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}\nvec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}\n\nfloat noise(vec3 p){\n    vec3 a = floor(p);\n    vec3 d = p - a;\n    d = d * d * (3.0 - 2.0 * d);\n\n    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);\n    vec4 k1 = perm(b.xyxy);\n    vec4 k2 = perm(k1.xyxy + b.zzww);\n\n    vec4 c = k2 + a.zzzz;\n    vec4 k3 = perm(c);\n    vec4 k4 = perm(c + 1.0);\n\n    vec4 o1 = fract(k3 * (1.0 / 41.0));\n    vec4 o2 = fract(k4 * (1.0 / 41.0));\n\n    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);\n    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);\n\n    return o4.y * d.y + o4.x * (1.0 - d.y);\n}\nvec2 cpow(vec2 b,float p){\n\tvec2 polar=vec2(pow(length(b),p),atan(b.y,b.x)*p);\n\tvec2 rect=vec2(cos(polar.x),sin(polar.x))*polar.y;\n\treturn rect;\n}\nvec2 m(vec2 a,vec2 b){\n\treturn vec2(a.x*b.x-a.y*b.y,a.x*b.y+a.y*b.x);\n}\nvec2 aT(vec2 i,vec2 z){\n\treturn vec2(0.0,-1.0)+m(i,z);\n}\nvec2 bT(vec2 i,vec2 z){\n\treturn vec2(0.0,1.0)-m(i,z);\n}\nvec2 nT(vec2 i,vec2 z,float p,int n,float l){\n\treturn vec2(cos(floor(p*float(n))/float(n)*atan(0.0,-1.0)*2.0),sin(floor(p*float(n))/float(n)*atan(0.0,-1.0)*2.0))+l*m(i,z);\n}\nfloat n(float q){\n\treturn mod(mod(q*sqrt(5.0),1.0)+1.0,1.0);\n}\nfloat rad(vec2 z,float iters){\n\treturn 1.0/(1.0-length(z))*pow(length(z),iters);\n}\nvec3 hsv2rgb(vec3 c)\n{\n    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);\n    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);\n    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);\n}\nvoid main( void ) {\n\tfloat scale=4.0;\n\tvec2 position = (( gl_FragCoord.xy / resolution.xy )-vec2(0.5))*resolution.xy/resolution.y*scale;//+vec2(1.0,0.0);\n\tvec2 pt=vec2(1.0,0.0);//texture2D(backbuffer,gl_FragCoord.xy/resolution.xy).xy*sc-vec2(2.0);\n\tvec2 o=length(position)>1.0?position/pow(length(position),2.0):position;\n\tvec3 color=texture2D(backbuffer,gl_FragCoord.xy/resolution.xy).xyz*0.999;\n\tbool close=false;//length(texture2D(backbuffer,gl_FragCoord.xy/resolution.xy).xyz)>0.95;\n\tif(length(o)<=1.0){\n\t\tif(!close){\n\t\t\tfor(int j=0;j<mx;j++){\n\t\t\t\tfloat le=mod(time*sqrt(2.0),1.0)+scale/resolution.y*1.0;\n\t\t\t\tpt=vec2(0.0,mod(time*sqrt(2.0),1.0)+scale/resolution.y*1.0);\n\t\t\t\tif(mod(float(j),2.0)<1.0){\n\t\t\t\t\tpt=vec2(mod(time*sqrt(2.0),1.0)+scale/resolution.y*1.0,0.0);\n\t\t\t\t}\n\t\t\t\tif(mod(float(j),4.0)<2.0){\n\t\t\t\t\tpt=-pt;\n\t\t\t\t}\n\t\t\t\tfloat a=floor((float(j)/float(mx)*3.14159265*2.0+time)/(3.14159265*2.0)*4.0)*(3.14159265*2.0)/4.0;//+noise(vec3(time*1000.0))*3.14159265*2.0;\n\t\t\t\tpt=mod(vec2(cos(a),sin(a))*0.5*le-vec2(0.5),1.0)+vec2(0.5);///10.0;\n\t\t\t\t\n\t\t\t\tfloat ite=3.0;\n\t\t\t\t//pt=pt*pow(2.0,ite);\n\t\t\t\tvec2 start=pt;\n\t\t\t\t//pt=position.yx*(mod(time*sqrt(2.0),1.0)+scale/resolution.y*1.0);\n\t\t\tfloat q=noise(vec3(time*(1010.0+sqrt(5.0)),float(j)*sqrt(15.0),1.0))*2.0;\n\t\t\tfloat g=mod(q*2.0,2.0);\n\t\t\tfloat startM=g;\n\t\t\tint minI=0;\n\t\t\tfor(int i=0;i<50;i++){\n\t\t\t\tfloat l=1.0;\n\t\t\t\tif(mod(float(j),2.0)<1.0){\n\t\t\t\t\t//l=-l;\n\t\t\t\t}\n\t\t\t\tpt=nT(pt,o,noise(vec3(float(i)*15.11123,time*11.013223,float(j)*3.56456))*101.55,1,l);\n\t\t\t\tif(length(pt)>rad(o,float(i))+scale/resolution.y){\n\t\t\t\t\tbreak;\n\t\t\t\t}\n\t\t\t\t\n\t\t\t\tif(length(pt)<scale/resolution.y*rad(o,float(i))){//scale/resolution.y*1.0&& i>0){\n\t\t\t\t\tminI=i;\n\t\t\t\t\t\tclose=true;\n\t\t\t\t\t\t//if(length(color)<1.0-1.0/5.0){\n\t\t\t\t\t\t//color+=normalize(hsv2rgb(vec3(float(i)/10.0,1.0,1.0)))/500.0;\n\t\t\t\t\t\t//}\n\t\t\t\t\t\t//break;\n\t\t\t\t\t}\n\t\t\t\t\n\t\t\t}\n\t\t\t\tif(minI>0){//scale/resolution.y*1.0&& i>0){\n\t\t\t\t\t\tclose=true;\n\t\t\t\t\t\tif(length(color)<1.0-1.0/5.0){\n\t\t\t\t\t\tcolor+=normalize(hsv2rgb(vec3(float(minI)/10.0,1.0,1.0)))/5.0;\n\t\t\t\t\t\t}\n\t\t\t\t\t\t//break;\n\t\t\t\t\t}\n\t\t}\n\t\t}\n\t}\n\tgl_FragColor = vec4( color, 1.0 );\n\tif(length(mouse)<0.1){\n\t\tgl_FragColor=vec4(vec3(0.0),1.0);\n\t}\n\t//gl_FragColor=vec4(vec3(n(position.x)),1.0);\n\n}", "user": "b2f8086", "parent": "/e#46930.14", "id": 46955}