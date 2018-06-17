{"code": "/*\n * Original shader from: https://www.shadertoy.com/\n */\n\n//#extension GL_OES_standard_derivatives : enable\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n// glslsandbox uniforms\nuniform float time;\nuniform vec2 resolution;\n\n// shadertoy globals\nfloat iTime;\nvec3  iResolution;\nconst vec3 iMouse = vec3(0.);\n\n// --------[ Original ShaderToy begins here ]---------- //\n//Sparse grid marching by nimitz (@stormoid)\n\n/*\n\tSomewhat efficient way of marching through\n\ta sparse repeated 3d grid (works in any dimension).\n\n\tGetting aligned ray-box intersection to get\tcell exit \n\tdistance when a cell is empty.  I think this is similar\n\tto the way iq has done voxel raymarching (haven't studied\n\this voxelizer code)\n*/\n\n#define ITR 100\n#define FAR 100.\n#define time iTime\n\n//#define SHOW_CELLS\n\nconst float c = 2.6; //Repetition factor\nconst float sz = .65; //Object size (no more than 1/3 the rep factor since objects are rotating)\nconst float scr = 0.94; //Scarcity\n\nvec3 rd = vec3(0);\nfloat matid = 0.;\n\n//Helper consts\nconst float ch = c*0.5;\nconst float ch2 = ch +.01;\nconst float scr2 = scr + (1.-scr)*1./3.;\nconst float scr3 = scr + (1.-scr)*2./3.;\n\nmat2 mm2(in float a){float c = cos(a), s = sin(a);return mat2(c,s,-s,c);}\nfloat hash(vec2 x){\treturn fract(cos(dot(x.xy,vec2(2.31,53.21))*124.123)*412.0); }\n\n//From Dave (https://www.shadertoy.com/view/XlfGWN)\nfloat hash13(vec3 p){\n\tp  = fract(p * vec3(.16532,.17369,.15787));\n    p += dot(p.xyz, p.yzx + 19.19);\n    return fract(p.x * p.y * p.z);\n}\n\nfloat dBox(in vec3 ro) \n{\n    vec3 m = 1.2/rd;\n    vec3 t = -m*ro + abs(m)*ch2;\n\treturn min(min(t.x, t.y), t.z);\n}\n\nfloat hash(in float n){ return fract(sin(n)*43758.5453); }\n\n//knighty's cut&fold technique\nfloat tetra(in vec3 p, in float sz)\n{\n    vec3 q = vec3(0.816497,0.,0.57735)*sz;\n    const vec3 nc = vec3(-0.5,-0.5,0.7071);\n    p.xy = abs(p.xy);\n   \tfloat t = 2.*dot(p,nc);\n    p -= t*nc;\n    p.xy = abs(p.xy);\n    t = 2.*min(0.,dot(p,nc));\n    p = (p-t*nc)-q;\n    return length(p.yz)-0.05;\n}\n\nvec3 maptex(vec3 p)\n{\n \tp.z -= hash(floor(p.x/c+1.))*(time*12.+92.);\n    p.y -= hash(floor(p.z/c+1.))*(time*3.+89.);\n    vec3 iq = floor(p);\n    p = fract(p)-0.5;\n    p.xz *= mm2(time*2.+iq.x);\n    p.xy *= mm2(time*0.6+iq.y);\n    return p;\n}\n\nvec3 maptex2(vec3 p)\n{\n \tvec3 g = p;\n    vec3 gid = floor(p/20.);\n    g.xy *= mm2(-gid.z*.4);\n    g.xz = mod(g.xz,20.)-10.;\n    return g;\n}\n\nfloat slength(in vec2 p){ return max(abs(p.x), abs(p.y)); }\nfloat map(vec3 p)\n{\n    vec3 g = p;\n    vec3 gid = floor(p/20.);\n    //movement\n    p.z -= hash(floor(p.x/c+1.))*(time*12.+92.);\n    p.y -= hash(floor(p.z/c+1.))*(time*3.+89.);\n    \n    vec3 iq = floor(p/c);\n    vec3 q  = mod(p,c)-ch;\n   \n    matid = dot(iq,vec3(1,11,101));\n    \n    float rn = hash13(iq);\n   \tfloat d = dBox(q); //Base distance is cell exit distance\n    \n    q.xz *= mm2(time*2.+iq.x);\n    q.xy *= mm2(time*0.6+iq.y);\n    \n    if (rn >= scr3)\n        d = min(d,length(q)-sz);\n    else if (rn >= scr2)\n        d = min(d,tetra(q,sz));\n    else if (rn >= scr)\n        d = min(d,dot(abs(q),vec3(0.57735))-sz);\n    \n    //columns\n    g.xy *= mm2(-gid.z*.4);\n    g.xz = mod(g.xz,20.)-10.;\n    float clm = slength(g.zx)-2.;\n    if (clm < d) matid = 1.;\n    d = min(d,clm);\n        \n    return d;    \n}\n\nfloat march(in vec3 ro, in vec3 rd)\n{\n\tfloat precis = 0.005;\n    float h=precis*2.0;\n    float d = 0.;\n    for( int i=0; i<ITR; i++ )\n    {\n        if( abs(h)<precis || d>FAR ) break;\n        d += h;\n\t    float res = map(ro+rd*d);\n        h = res;\n        #ifdef SHOW_CELLS \n        rd.xy *= d*0.00001+.996;\n        #endif\n    }\n\treturn d;\n}\n\nvec3 rotx(vec3 p, float a){\n    float s = sin(a), c = cos(a);\n    return vec3(p.x, c*p.y - s*p.z, s*p.y + c*p.z);\n}\n\nvec3 roty(vec3 p, float a){\n    float s = sin(a), c = cos(a);\n    return vec3(c*p.x + s*p.z, p.y, -s*p.x + c*p.z);\n}\n\n//From TekF (https://www.shadertoy.com/view/ltXGWS)\nfloat cells(in vec3 p)\n{\n    p = fract(p/2.0)*2.0;\n    p = min( p, 2.0-p );\n    return min(length(p),length(p-1.0));\n}\n\nvec3 bg(in vec3 d)\n{\n    return abs(sin(vec3(1.,2.,2.5)+sin(time*0.05)))*0.4+.35*(cells(d*.5)*0.4+0.6);\n}\n\nfloat bnoise(in vec3 p)\n{\n    float n = cells(p*15.);\n    n = max(n,cells(p*12.));\n    n = (n + exp(n*3.-4.))*.002;\n    return n;\n}\n\nvec3 bump(in vec3 p, in vec3 n, in float ds)\n{\n    vec2 e = vec2(.01,0);\n    float n0 = bnoise(p);\n    vec3 d = vec3(bnoise(p+e.xyy)-n0, bnoise(p+e.yxy)-n0, bnoise(p+e.yyx)-n0)/e.x;\n    n = normalize(n+d*5./clamp(sqrt(ds),1.,5.));\n    return n;\n}\n\nvec3 normal(in vec3 p)\n{  \n    vec2 e = vec2(-1., 1.)*0.005;   \n\treturn normalize(e.yxx*map(p + e.yxx) + e.xxy*map(p + e.xxy) + \n\t\t\t\t\t e.xyx*map(p + e.xyx) + e.yyy*map(p + e.yyy) );   \n}\n\nvec3 shade(in vec3 p, in vec3 rd, in vec3 lpos, in float d)\n{\n\tvec3 n = normal(p);\n    vec3 col = vec3(1);\n    if (matid < 0.)\n    {\n       \tcol = sin(vec3(1,2,3.)+matid*.002)*0.3+0.4;\n        n = bump(maptex(p*0.5),n,d);\n    }\n    else\n    {\n        n = bump(maptex2(p*0.25),n,d);\n    }\n    \n    vec3 r = reflect(rd,n);\n    vec3 ligt = normalize(lpos-p);\n    float atn = distance(lpos,p);\n    float refl = pow(dot(rd, r)*.75+0.75,2.);\n    float dif = clamp(dot(n, ligt),0.,1.);\n    float bac = clamp(dot(n, vec3(-ligt)),0.,1.);\n    col = col*bac*0.2 + col*dif*.3 + bg(r)*dif*refl*0.2;\n    col *= clamp((1.-exp(atn*.15-5.)),0.,1.);\n\t\n\treturn col;\n}\n\n//From mu6k\nvec3 cc(vec3 col, float f1,float f2)\n{\n\tfloat sm = dot(col,vec3(1));\n\treturn mix(col, vec3(sm)*f1, sm*f2);\n}\n\n//from p_malin\nvec3 flare(in vec3 ro, in vec3 rd, in float t, in vec3 lpos, in float spread)\n{\n    float dotl = dot(lpos - ro, rd);\n    dotl = clamp(dotl, 0.0, t);\n\n    vec3 near = ro + rd*dotl;\n    float ds = dot(near - lpos, near - lpos);\n\treturn (vec3(1.,0.7,0.3) * .01/(ds));\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\t\n\tvec2 p = fragCoord.xy/iResolution.xy-0.5;\n\tp.x*=iResolution.x/iResolution.y;\n\tvec2 mo = iMouse.xy / iResolution.xy-.5;\n    mo = (mo==vec2(-.5))?mo=vec2(0.):mo;\n    mo*= 0.5;\n    mo += vec2(0.4,-0.4);\n\tmo.x *= iResolution.x/iResolution.y;\n\t\n    vec3 ro = vec3(0,0,-time*20.);\n    rd = normalize(vec3(p,-1.));\n    //rd.z += length(rd)*0.5;\n    rd = rotx(rd,mo.y+sin(time*0.4)*0.5);\n    rd = roty(rd,-mo.x+cos(time)*0.1);\n\t\n\tfloat rz = march(ro,rd);\n\t\n    vec3 col = vec3(0.05);\n    vec3 bgc = bg(rd*5.)*0.5;\n    vec3 pos = ro + rd*FAR;\n    vec3 lpos = ro + vec3(0,sin(time*1.)*2., -15.+sin(time*0.5)*10.); \n    \n    if ( rz < FAR )\n    {\n        pos = ro+rz*rd;\n        float d= distance(ro,pos);\n        col = shade(pos, rd,lpos, d);\n    }\n\t\n    col = mix(col, bgc, smoothstep(FAR-40.,FAR,rz));\n    col += flare(ro,rd,rz,lpos,1.);\n    \n    //Post\n\t#if 1\n    col = clamp(col,0.,1.)*1.3;\n\tcol -= hash(col.xy+p.xy)*.017; //Noise\n\tcol -= smoothstep(0.15,1.9,length(p*vec2(1,1.5)))*.6; //Vign\n    col = pow(clamp(col,0.,1.),vec3(0.8));\n    col =cc(col,.6,.3); //Color modifier\n    #endif\n    \n\tfragColor = vec4( col, 1.0 );\n}\n// --------[ Original ShaderToy ends here ]---------- //\n\n#undef time\n\nvoid main(void)\n{\n    iTime = time;\n    iResolution = vec3(resolution, 0.0);\n\n    mainImage(gl_FragColor, gl_FragCoord.xy);\n}", "user": "84cf087", "parent": "/e#47208.0", "id": 47314}