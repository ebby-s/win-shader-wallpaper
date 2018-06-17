{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n// Star Nest by Pablo Rom\u00e1n Andrioli\n// Modified a lot.\n\n// This content is under the MIT License.\n\n#define iterations 18\n#define formuparam 0.43\n\n#define volsteps 16\n#define stepsize 0.170\n\n#define zoom   03.900\n#define tile   01.850\n#define speed  0.0031\n\n#define brightness 0.00550\n#define darkmatter 0.800\n#define distfading 0.660\n#define saturation 0.900\n\n\nvoid main(void)\n{\n\t//get coords and direction\n\tvec2 uv=gl_FragCoord.xy/resolution.xy-.5;\n\tuv.y*=resolution.y/resolution.x;\n\tvec3 dir=vec3(uv*zoom,1.);\n\t\n\tfloat a2=time*speed+.5;\n\tfloat a1=0.0;\n\tmat2 rot1=mat2(cos(a1),sin(a1),-sin(a1),cos(a1));\n\tmat2 rot2=rot1;//mat2(cos(a2),sin(a2),-sin(a2),cos(a2));\n\tdir.xz*=rot1;\n\tdir.xy*=rot2;\n\t\n\t//from.x-=time;\n\t//mouse movement\n\tvec3 from=vec3(0.,0.,0.);\n\tfrom+=vec3(.05*time,.05*time,-2.);\n\t\n\t//from.x-=mouse.x;\n\t//from.y-=mouse.y;\n\t\n\tfrom.y -= 200.;\n\t\n\tfrom.xz*=rot1;\n\tfrom.xy*=rot2;\n\t\n\t//volumetric rendering\n\tfloat s=.4,fade=.2;\n\tvec3 v=vec3(0.4);\n\tfor (int r=0; r<volsteps; r++) {\n\t\tvec3 p=from+s*dir*.5;\n\t\tp = abs(vec3(tile)-mod(p,vec3(tile*2.))); // tiling fold\n\t\tfloat pa,a=pa=0.;\n\t\tfor (int i=0; i<iterations; i++) { \n\t\t\tp=abs(p)/dot(p,p)-1.1*formuparam; // the magic formula\n\t\t\ta+=abs(length(p)-pa); // absolute sum of average change\n\t\t\tpa=length(p);\n\t\t}\n\t\tfloat dm=max(0.,darkmatter-a*a*.001); //dark matter\n\t\ta*=a*a*2.; // add contrast\n\t\tif (r>3) fade*=1.-dm; // dark matter, don't render near\n\t\t//v+=vec3(dm,dm*.5,0.);\n\t\tv+=fade;\n\t\tv+=vec3(s,s*s,s*s*s*s)*a*brightness*fade; // coloring based on distance\n\t\tfade*=distfading; // distance fading\n\t\ts+=stepsize;\n\t}\n\tv=mix(vec3(length(v)),v,saturation); //color adjust\n\tgl_FragColor = vec4(v*.01,1.);\t\n\t\n}", "user": "335daa8", "parent": "/e#15740.0", "id": "15772.0"}