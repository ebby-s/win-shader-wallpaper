{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n// ShaderToy compatibility layer\n\nfloat iTime;\nvec2 iMouse;\nvec2 iResolution;\n\nvoid mainImage( out vec4 iFragColor, in vec2 fragCoord );\n\nvoid main( void ) {\n  iTime = time;\n  iMouse = mouse;\n  iResolution = resolution;\n  mainImage(gl_FragColor, gl_FragCoord.xy);\n}\n\n\n// Original shadertoy https://www.shadertoy.com/view/XtfXDN\n\n// [SIG15] Oblivion\n// by David Hoskins.\n// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.\n\n// The Oblivion drone. I love all the scenes that include these things.\n// It takes bits from all over:-\n// https://www.youtube.com/watch?v=rEby9OkePpg&feature=youtu.be\n// These drones were the true stars of the film!\n\n// You might need to rewind to sync the audio properly.\n\n// Some info, if you want to know:-\n// The camera is delayed when following the drone to make it feel hand held.\n// The rendering layers consist of:-\n// 1. Background, including sky, ground and shadow. Plus a check for a possible heat haze\n//    to bend the ray, before beginning trace.\n// 2. Anti-aliased drone ray-marching, which is traced from just in front to just behind it for speed.\n// 3. Clouds, and fogging.\n// 4. Foreground, for ID scanner\n\n#define PI 3.14156\n#define TAU 6.2831853071\n#define MOD2 vec2(443.8975,397.2973)\n#define MOD3 vec3(443.8975,397.2973, 491.1871)\n\nconst vec2 add = vec2(1.0, 0.0);\nvec3 sunDir = normalize(vec3(-2.3, 3.4, -5.89));\nconst vec3 sunCol = vec3(1.0, 1.0, .9);\nvec2 gunMovement;\nvec3 drone;\nvec3 droneRots;\nfloat scannerOn;\nvec4 dStack;\nvec4 eStack;\nint emitionType = 0;\n\n//----------------------------------------------------------------------------------------\n// Action cue sheet, for easy manipulation...\n#define cueINCLOUDS 0.0\n#define cueFLYIN 14.0\n#define cueFRONTOF cueFLYIN + 10.0\n#define cueTHREAT cueFRONTOF + 5.\n#define cueFLYOFF cueTHREAT + 19.0\n\n//----------------------------------------------------------------------------------------\n// A hash that's the same on all platforms...\nvec3 hash32(vec2 p)\n{\n\tvec3 p3 = fract(vec3(p.xyx) * MOD3);\n    p3 += dot(p3.zxy, p3.yxz+19.19);\n    return fract(vec3(p3.x * p3.y, p3.x*p3.z, p3.y*p3.z));\n}\n\n//----------------------------------------------------------------------------------------\nvec3 hash31(float p)\n{\n   vec3 p3 = fract(vec3(p) * MOD3);\n   p3 += dot(p3.xyz, p3.yzx + 19.19);\n   return fract(vec3(p3.x * p3.y, p3.x*p3.z, p3.y*p3.z));\n}\n\n//----------------------------------------------------------------------------------------\nvec3 noise3(float n)\n{\n    float f = fract(n);\n    n = floor(n);\n    f = f*f*(3.0-2.0*f);\n    return mix(hash31(n), hash31(n+1.0), f);\n}\n\n//----------------------------------------------------------------------------------------\nvec3 noise( in vec2 x )\n{\n    vec2 p = floor(x);\n    vec2 f = fract(x);\n    f = f*f*(1.5-f)*2.0;\n    \n    vec3 res = mix(mix( hash32(p), hash32(p + add.xy),f.x),\n               mix( hash32(p + add.yx), hash32(p + add.xx),f.x),f.y);\n    return res;\n}\n\n\n//----------------------------------------------------------------------------------------\n// CubeMap OpenGL clamping fix. Why do I have to do this?\nvec3 cubeMap(in samplerCube sam, in vec3 v, float size)\n{\n   float M = max(max(abs(v.x), abs(v.y)), abs(v.z));\n   float scale = (float(size) - 1.) / float(size);\n   if (abs(v.x) != M) v.x *= scale;\n   if (abs(v.y) != M) v.y *= scale;\n   if (abs(v.z) != M) v.z *= scale;\n   return textureCube(sam, v).xyz;\n}\n\n// Thanks to iq for the distance functions...\n//----------------------------------------------------------------------------------------\nfloat circle(vec2 p, float s )\n{\n    return length(p)-s;\n}\n//----------------------------------------------------------------------------------------\nfloat  sphere(vec3 p, float s )\n{\n    return length(p)-s;\n}\n\nfloat prism( vec3 p, vec2 h )\n{\n    vec3 q = abs(p);\n    return max(q.x-h.y,max(q.z*0.6+p.y*.5,-p.y)-h.x*0.5);\n}\n\n//----------------------------------------------------------------------------------------\nfloat prismFlip( vec3 p, vec2 h )\n{\n    vec3 q = abs(p);\n    return max(q.x-h.y,max(q.z*.8-p.y*.5,p.y)-h.x*0.5);\n}\n\n//----------------------------------------------------------------------------------------\nfloat roundedSquare( vec2 p, vec2 b)\n{\n  vec2 d = abs(p) - b;\n  return min(max(d.x,d.y),0.0) + length(max(d,0.0));\n    \n}\n\n//----------------------------------------------------------------------------------------\nfloat roundedBox( vec3 p, vec3 b, float r )\n{\n\treturn length(max(abs(p)-b,0.0))-r;\n}\n\n//----------------------------------------------------------------------------------------\nfloat sMin( float a, float b, float k )\n{\n    \n\tfloat h = clamp(0.5 + 0.5*(b-a)/k, 0.0, 1.0 );\n\treturn mix( b, a, h ) - k*h*(1.-h);\n}\n\n//----------------------------------------------------------------------------------------\nvec2 rot2D(inout vec2 p, float a)\n{\n    return cos(a)*p - sin(a) * vec2(p.y, -p.x);\n}\n\n//----------------------------------------------------------------------------------------\nvec3 rot3DXY(in vec3 p, in vec2 a)\n{\n\tvec2 si = sin(a);\n\tvec2 co = cos(a);\n    p.xz *= mat2(co.y, -si.y, si.y, co.y);\n    p.zy *= mat2(co.x, -si.x, si.x, co.x);\n    return p;\n}\n\n//----------------------------------------------------------------------------------------\nfloat boxMap( sampler2D sam, in vec3 p, in vec3 n)\n{\n    p = p*vec3(.1, .03, .1);\n    n = abs(n);\n\tfloat x = texture2D( sam, p.xy ).y;\n\tfloat y = texture2D( sam, p.xy ).y;\n\tfloat z = texture2D( sam, p.xy ).y;\n\treturn (x*n.x + y*n.y + z*n.z)/(n.x+n.y+n.z);\n}\n\nfloat tri(in float x){return abs(fract(x)-.5);}\nvec3 tri3(in vec3 p){return vec3( tri(p.z+tri(p.y*1.)), tri(p.z+tri(p.x*1.)), tri(p.y+tri(p.x*1.)));}\n\nfloat triNoise3d(in vec3 p, in float spd, float ti)\n{\n    float z=1.1;\n\tfloat rz = 0.;\n    vec3 bp = p*1.5;\n\tfor (float i=0.; i<=3.; i++ )\n\t{\n        vec3 dg = tri3(bp);\n        p += (dg+spd);\n        bp *= 1.9;\n\t\tz *= 1.5;\n\t\tp *= 1.3;\n        \n        rz+= (tri(p.z+tri(p.x+tri(p.y))))/z;\n        bp += 0.14;\n\t}\n\treturn rz;\n}\n\nfloat fogmap(in vec3 p, in float d, float ti)\n{\n    p.xz *= .4;\n    p.z += ti*1.5;\n    return max(triNoise3d(p*.3/(d+20.),0.2, ti)*1.8-.7, 0.)*(smoothstep(0.,25.,p.y));\n}\n// Thanks to nimitz for the quick fog/clouds idea...\n// https://www.shadertoy.com/view/4ts3z2\nvec3 clouds(in vec3 col, in vec3 ro, in vec3 rd, in float mt, float ti)\n{\n    float d = 3.5;\n    for(int i=0; i<7; i++)\n    {\n        if (d>mt)break;\n        vec3  pos = ro + rd*d;\n        float rz = fogmap(pos, d, ti);\n        vec3 col2 = (vec3(.4,0.4,.4));\n        col = mix(col,col2,clamp(rz*smoothstep(d,d*1.86,mt),0.,1.) );\n        d *= 1.86;\n        \n    }\n    return col;\n}\n\n//----------------------------------------------------------------------------------------\nvec4 numbers(vec4 mat, vec2 p)\n{\n    p.y *= 1.70;\n    p.y+=.32;\n\tfloat d;\n\td =(roundedSquare(p+vec2(1.4, -.25), vec2(.02, .76)));\n  \td =min(d, (roundedSquare(p+vec2(1.48, -1.04), vec2(.1, .06))));\n\n    vec2 v = p;\n    v.x -= v.y*.6;\n    v.x = abs(v.x+.149)-.75;\n\td = min(d, roundedSquare(v+vec2(0.0, -.7), vec2(.07, .4)));\n    v = p;\n    v.x -= v.y*.6;\n    v.x = abs(v.x-.225)-.75;\n    p.x = abs(p.x-.391)-.75;\n  \td = min(d, circle(p, .5));\n   \td = max(d, -circle(p, .452));\n    d = max(d, -roundedSquare(v+vec2(0., -.87), vec2(.33, .9)));\n    \n    mat = mix(mat, vec4(.8), smoothstep(0.2, .13, d));\n    return mat;\n}\n\n//----------------------------------------------------------------------------------------\n// Find the drone...\nfloat mapDE(vec3 p)\n{\n    p -= drone.xyz;\n    p = rot3DXY(p, droneRots.xy);\n\n    float d = sphere(p, 10.0);\n\tvec3 v = p;\n    v.xy = abs(v.xy);\n    v.xy = rot2D(v.xy, -PI/6.2);\n    // Cross pieces...\n    d = sMin(d, roundedBox(v-vec3(0,0,-8), vec3(4.9, .3, .5), 1.), 1.2); \n    d = max(d, -roundedBox(v-vec3(0,0,-8.5), vec3(4.8, .3, 1.), 1.));\n    \n    // Centre cutout...\n    //d = sMin(d, roundedBox(p-vec3(0,0,-8.5), vec3(1.3, 1.4, 1.5), .7), .4); \n    d = max(d,-roundedBox(p-vec3(0,0,-9.1), vec3(2., 1.5, 4.0), .7)); \n    // Inside...\n    d = min(d, sphere(p, 8.8));\n    d = max(d, roundedBox(p, vec3(6.5, 12, 12.0), .8)); \n    // Make back...\n    d = sMin(d, prismFlip(p+ vec3(.0, -4.1, -8.1), vec2(7., 4.7) ), 1.);\n    d = max(d, -prism(p + vec3(.0, 6.4, -11.4), vec2(8.0, 10.0) ));\n    d = min(d, sphere(p+ vec3(.0, 5.6, -6.2), 3.0));\n    \n    // Eye locations../\n    d = min(d, sphere(v+ vec3(-3.5, .0, 7.4), 1.1));\n    \n    v = p;\n    v.x = abs(v.x);\n    d = sMin(d, roundedBox(v+vec3(-4.2,-6.,-10.0), vec3(1.1, .1, 4.5), 1.), 2.4); \n    \n    v =abs(p)-vec3(gunMovement.x, .0, 0.) ;\n    v.x -= p.z*.1*gunMovement.y;\n\tfloat d2 = sphere(v, 10.0);\n    d2 = max(d2, -roundedBox(v, vec3(6.55, 12, 12.0), .8)); \n    d = min(d2 ,d);\n    d = min(d,roundedBox(v-vec3(5.5, 3.5, 3.5), vec3(2.3, .1, .1), .4));\n    d = min(d,roundedBox(v-vec3(5.5, .0, 5.), vec3(2.4, .1, .1), .4));\n\n    v =vec3(abs(p.xy)-vec2(gunMovement.x, .0), p.z);\n    v.x -= p.z*.1*gunMovement.y;\n\n    d = min(d, roundedBox(v-vec3(8., 2.8, -6.5), vec3(.3, 1., 3.), .2));\n    d = min(d, roundedBox(v-vec3(8., 2.3, -10.), vec3(.2, .4, 1.2), .2));\n    d = min(d, roundedBox(v-vec3(8., 3.4, -10.), vec3(.01, .01, 1.2), .4));\n    d = max(d, -roundedBox(v-vec3(8., 3.4, -10.4), vec3(.01, .01, 1.2), .3));\n    d = max(d, -roundedBox(v-vec3(8., 2.3, -10.4), vec3(.01, .01, 1.2), .3));\n    \n    d = min(d,  roundedBox(v-vec3(8.55, 0, -4.5), vec3(.4, .2, 1.), .4));\n    d = max(d, -roundedBox(v-vec3(8.65, 0, -4.5), vec3(.0, .0, 2.), .34));\n       \n    return d;\n}\n\n//---------------------------------------------------------------------------\nfloat bumpstep(float edge0, float edge1, float x)\n{\n    return 1.0-abs(clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0)-.5)*2.0;\n}\n\n//----------------------------------------------------------------------------------------\n// Find the drone's material...yes, it's IFtastic! :D\nvec4 mapCE(vec3 p, vec3 nor)\n{\n    vec4 mat;\n    p -= drone.xyz;\n\tp = rot3DXY(p, droneRots.xy);\n\n    const vec4 gunMetal = vec4(.05, .05, .05,.3);\n    vec4 body     = vec4(.8, .8, .8,.4);\n   \n    float dirt1 = 1.0;//smoothstep(-.1, .5,boxMap(iChannel1,p, nor))*.25+.75;\n    mat = body*dirt1;\n  \n    float d = sphere(p+vec3(0,0,.5), 8.9);\n    float d2;\n    d = max(d, roundedBox(p, vec3(6., 12, 11.0), .72)); \n    if (d < .0 || p.z > 14.5)\n    {\n        d = sphere(p-vec3(-3.3 , 1.8, -8.1), .9);\n        d2 = sphere(p-vec3(3.1 , 1.7, -8.1), .5);\n        // EyeCam...\n\t    if (d < 0.0)\n        {\n            mat = vec4(1., 0.03, 0.0, .7);\n            emitionType = 1;\n        }else\n\t\t// Scanner...\n       \tif (d2 < 0.0)\n       \t{\n            d2 = d2 < -.015 ? max(-circle(mod(p.xy-vec2(3.185 , 1.78), .16)-.08, .085)*35.0, 0.0): 1.0;\n\t\t\tmat = vec4(.2+scannerOn*.6, 0.2+scannerOn*.75, 0.2+scannerOn, .7*d2)*d2;\n            \n\t\t\temitionType = 2;\n      \t}\n        else\n\t        mat = numbers(gunMetal, p.xy);\n        // Do hex border line around numbers...\n        p = abs(p);\n        mat = p.x > p.y*.76 ? mix(mat, vec4(0.0), bumpstep(2.3, 2.4, p.x+p.y*.5)):mix(mat, vec4(0.0), bumpstep(1.82, 1.92, p.y));\n        return mat;\n    }\n\n     // Gun placements and carriers...\n    vec3 v = p;\n    \n   \t//v.yz = rot2D(p.yz, gunMovement.x);\n\tv =abs(v)-vec3(gunMovement.x, .0, 0.) ;\n    v.x -= p.z*.1*gunMovement.y;\n\td2 = sphere(v, 10.0);\n    d2 = max(d2, -roundedBox(v, vec3(6.55, 12, 4.0), 1.1)); \n    \n    d = min(d2, d);\n    d2 = min(d,\troundedBox(v-vec3(5.5, 3.5, 3.5), vec3(2.3, .1, .1), .4));\n    //d2 = min(d2,roundedBox(v-vec3(5.5, .0, 3.7), vec3(2.3, .1, .1), .4));\n    d2 = min(d2, sphere(v-vec3(5., .0, 3.7), 3.8));\n    if(d2 < d) mat = vec4(.0, .0, .0, 6.);\n    //return mat;\n    \n    v = vec3(abs(p.x)-gunMovement.x, p.yz);\n    v.x -= p.z*.1*gunMovement.y;\n    float dirt = 1.0;//(smoothstep(-.1, .5,boxMap(iChannel1,v, nor))*.2+.8);\n    body = body * dirt;\n \n    v = vec3(abs(p.xy)-vec2(gunMovement.x, .0), p.z);\n    v.x -= p.z*.1*gunMovement.y;\n    \n    if ( v.x > 7.4)  mat =mix(body, gunMetal, smoothstep(2.5, 2.3, v.y))*dirt;\n    d2 =  roundedBox(v-vec3(8., 2.3, -10.5), vec3(.4, 1.6, 1.5), .2);\n    //if ( d2 < 0.1)  mat = gunMetal*dirt;\n    mat= mix(mat, gunMetal*dirt, clamp(-d2*10.0, 0.0, 1.0));\n    \n    d =  sphere(p+ vec3(.0, 5.6, -6.2), 3.2);\n    if ( d < 0.0)\n    {\n        mat = vec4(0);\n        emitionType = 3;\n    }\n\n    return mat;\n}\n\n//----------------------------------------------------------------------------------------\nfloat shadow( in vec3 ro, in vec3 rd)\n{\n\tfloat res = 1.0;\n    float t = .2;\n    for (int i = 0; i < 12; i++)\n\t{\n\t\tfloat h = mapDE( ro + rd*t );\n        if (h< -2.) break;\n\t\tres = min(10.*h / t, res);\n\t\tt += h+.2;\n\t}\n    return max(res, .3);\n}\n\n//----------------------------------------------------------------------------------------\nfloat SphereRadius(in float t)\n{\n    t = t*.003+.01;\n\treturn min(t,256.0/iResolution.x);\n}\n\n//----------------------------------------------------------------------------------------\nvoid rayMarch(vec3 pos, vec3 dir)\n{\n    // Efficiently start the ray just in front of the drone...\n    float l = max(length(drone-pos)-14.2, .0);\n    float d =  l;\n    l+=23.;// ...and end it just after\n    int hits = 0;\n\t// Collect 4 of the closest scrapes on the tracing sphere...\n    for (int i = 0; i < 55; i++)\n    {\n        // Leave if it's gone past the drone or when it's found 7 stacks points...\n        if(d > l || hits == 6) break;\n        vec3 p = pos + dir * (d);\n\t\tfloat r= SphereRadius(d);\n\t\tfloat de = mapDE(p);\n        // Only store the closest ones (roughly), which means we don't\n        // have to render the 8 stack points, just the most relavent ones.\n        // This also prevents the banding seen when using small stacks.\n        if(de < r &&  de < eStack.x)\n        {\n            // Rotate the stack and insert new value!...\n\t\t\tdStack = dStack.wxyz; dStack.x = d; \n            eStack = eStack.wxyz; eStack.x = de;\n\t\t\thits++;    \n        }\n\t\td +=de*.9;\n    }\n    return;\n}\n\n//----------------------------------------------------------------------------------------\nvec3 normal( in vec3 pos, in float r )\n{\n\tvec2 eps = vec2( r*1., 0.0);\n\tvec3 nor = vec3(\n\t    mapDE(pos+eps.xyy) - mapDE(pos-eps.xyy),\n\t    mapDE(pos+eps.yxy) - mapDE(pos-eps.yxy),\n\t    mapDE(pos+eps.yyx) - mapDE(pos-eps.yyx) );\n\treturn normalize(nor);\n}\n\n//----------------------------------------------------------------------------------------\nfloat terrain( in vec2 q )\n{\n    q *= .5;\n    q += 4.;\n\t/*\n\tfloat h = smoothstep( 0., 0.7, textureLod( iChannel1, 0.023*q,  0.0).x )*6.0;\n    h +=  smoothstep( 0., 0.7, textureLod( iChannel2, 0.03*q, 0.0 ).y )*3.0;\n*/\n    //h +=  smoothstep( 0., 1., texture( iChannel1, .01*q, 00.0 ).y )*1.0;\n    return 1.0;//h;\n}\n\n//----------------------------------------------------------------------------------------\nvec3 skyUpper(in vec3 rd)\n{\n    vec3  sky;\n    float f = pow(max(rd.y, 0.0), .5);\n    sky = mix(vec3(.45, .5, .6), vec3(.7, .7, .7), f);\n    float sunAmount = pow(max( dot( rd, sunDir), 0.0 ), 8.0);\n    sky = sky + sunCol * sunAmount*.5;\n    rd.xz = rd.zx;rd.y-=.05;\n    //sky -= (vec3(.65, .67, .75)-cubeMap(iChannel3, rd, 64.0).xyz)*.5;\n\n\treturn clamp(sky, 0.0, 1.0);\n}\n\n//----------------------------------------------------------------------------------------\nvec3 fogIt(in vec3 col, in vec3 sky, in float d)\n{\n    return mix (col, sky, clamp(1.0-exp(-d*0.001), 0.0, 1.0));\n}\n\n//----------------------------------------------------------------------------------------\nvec3 ground(vec3 sky, in vec3 rd, in vec3 pos)\n{\n  \n    if (rd.y > .0) return sky;\n \n\tfloat d = (-20.0-pos.y)/rd.y;\n\tvec2 p = pos.xz+rd.xz * d;\n    \n\t//vec3 tex1 = texture(iChannel1, p*.1).xyz;\n\t//vec3 tex2 = texture(iChannel2, p*.0004).yyx*vec3(1.0, .8, .8);\n\n\tvec3 gro  = vec3(1.);\n    \n    d-=20.0;\n\tfloat a = .0004*d*d;\n        \n\tvec3 nor  \t= vec3(0.0,\t\t    terrain(p), 0.0);\n\tvec3 v2\t\t= nor - vec3(a,\t\tterrain(p+vec2(a, 0.0)), 0.0);\n\tvec3 v3\t\t= nor - vec3(0.0,\t\tterrain(p+vec2(0.0, a)), -a);\n\tnor = cross(v2, v3);\n\tnor = normalize(nor);\n\t//gro = mix(tex1, tex2, nor.y*.8);\n\tfloat sha = shadow(vec3(p.x, 0.0, p.y),  sunDir);\n\tfloat z =max(dot(nor, sunDir), 0.1);\n    if (dStack[0] < 0.0) dStack[0]= d;\n    vec3 col = gro*z*sha;\n\n\treturn col = fogIt(col, sky, d);\n}\n\n\n\n//----------------------------------------------------------------------------------------\n// This is also used for the camera's delayed follow routine.\n// Which make the scene more dramitic because it's a human camera operator!\nvec3 dronePath(float ti)\n{\n    vec3 p = vec3(-2030, 500, 2400.0);\n    p = mix(p, vec3(-2030, 500, 2000.0),\t \tsmoothstep(cueINCLOUDS, cueFLYIN, ti));\n    p = mix(p, vec3(-30.0, 18.0, 300.0),\t\tsmoothstep(cueFLYIN, cueFLYIN+4.0, ti));\n    p = mix(p, vec3(-35.0, 25.0, 10.0), \t\tsmoothstep(cueFLYIN+2.0,cueFLYIN+8.0, ti));\n    p = mix(p, vec3(30.0, 0.0, 15.0), \t\t\tsmoothstep(cueFRONTOF+.5,cueFRONTOF+2.5, ti)); //../ Move to front of cam.\n    \n    p = mix(p, vec3(0.0, 8.0, .0), \t\t\t\tsmoothstep(cueTHREAT, cueTHREAT+.5, ti)); \t// ...Threaten\n    p = mix(p, vec3(0.0, 8.0, -4.0), \t\t\tsmoothstep(cueTHREAT+2.0, cueTHREAT+2.3, ti)); \t// ...Threaten\n    p = mix(p, vec3(0.0, 8., -12.0), \t\t\tsmoothstep(cueTHREAT+3.0, cueTHREAT+3.3, ti)); \t// ...Threaten\n    \n    p = mix(p, vec3(0.0, 110.0, 0.0), \t\t\tsmoothstep(cueFLYOFF,cueFLYOFF+1.5, ti)); // ...Fly off\n    p = mix(p, vec3(4000.0, 110.0, -4000.0), \tsmoothstep(cueFLYOFF+2.6,cueFLYOFF+10.0, ti)); \n    return p; \n}\n\n//----------------------------------------------------------------------------------------\nvec3 droneRotations(float ti)\n{\n    vec3 a = vec3(0);\n    \n    \n   \ta.x = mix(a.x, .2, smoothstep(cueFLYIN-3.0,cueFLYIN-1.5, ti));\n    a.x = mix(a.x, .0, smoothstep(cueFLYIN-1.5,cueFLYIN, ti));\n\n    a.y = mix(a.y, -.8,smoothstep(cueFLYIN-1.5,cueFLYIN, ti));\n\n    a.x = mix(a.x, .2,smoothstep(cueFLYIN+2.0,cueFLYIN+4.0, ti));\n    a.x = mix(a.x, 0.,smoothstep(cueFLYIN+4.0,cueFLYIN+6., ti));\n\n\ta.y = mix(a.y, 0.0, smoothstep(cueFLYIN+3.0,cueFLYIN+4.4, ti));\n    a.x = mix(a.x, .1,smoothstep(cueFLYIN+7.0,cueFLYIN+7.8, ti));\n    a.x = mix(a.x, 0.,smoothstep(cueFLYIN+7.8,cueFLYIN+8.3, ti));\n    \n\ta.y = mix(a.y, -1.5,smoothstep(cueFRONTOF,cueFRONTOF+.5, ti));// ..Turn to go right, infront\n\ta.y = mix(a.y, .6, \tsmoothstep(cueFRONTOF+3.,cueFRONTOF+4.5, ti));\n\n    a.y = mix(a.y, .0,  smoothstep(cueTHREAT,cueTHREAT+.5, ti));\n\n    a.x = mix(a.x, -.28,smoothstep(cueTHREAT, cueTHREAT+.3, ti)); // ...Threaten\n    \n    a.x = mix(a.x, 0.0, smoothstep(cueFLYOFF-2.0, cueFLYOFF, ti)); // Normalise position, relax!\n    a.x = mix(a.x, -0.5,smoothstep(cueFLYOFF, cueFLYOFF+.2, ti)); \t// ...Fly off\n    a.x = mix(a.x, 0.0, smoothstep(cueFLYOFF+.2, cueFLYOFF+.7, ti));\n    \n    a.y = mix(a.y, -.78,smoothstep(cueFLYOFF+2., cueFLYOFF+2.3, ti)); \n    \n    scannerOn = smoothstep(cueTHREAT+4.0,cueTHREAT+4.2, ti)* smoothstep(cueTHREAT+11.5,cueTHREAT+11.2, ti);\n    a.z = sin(ti*2.) * scannerOn;\n\n    return a;\n}\n\n//----------------------------------------------------------------------------------------\nvec2 droneGunAni(float ti)\n{\n    vec2 a;\n   \tfloat mov = smoothstep(cueTHREAT+.5, cueTHREAT+1.5, ti);\n    mov = mov * smoothstep(cueFLYOFF-1., cueFLYOFF-3.0, ti);\n    mov = mov*3.1-1.4;\n    a.x = (sin(mov)+1.0)*1.5;\n    a.y = smoothstep(.3,.7,sin(mov))*3.0;\n    return a;\n}\n\n//----------------------------------------------------------------------------------------\nvec3 cameraAni(float ti)\n{\n    vec3 p;\n    p = mix(drone-vec3(0.0,0.0, 10.0), drone-vec3(0.0,0.0, 20.0), smoothstep(cueINCLOUDS,cueINCLOUDS+2.0, ti));\n    p = mix(p, drone-vec3(17.0,-14.0, 35.0), smoothstep(cueINCLOUDS+2.0,cueFLYIN-3.0, ti));\n\n    p = mix(p, vec3(0.0, 0.0, -28.0), step(cueFLYIN, ti));\n\tp = vec3(p.xy, mix(p.z, -40.0, smoothstep(cueTHREAT,cueTHREAT+4.0, ti)));\n    return p;\n}\n\n//----------------------------------------------------------------------------------------\nfloat overlay(vec3 p, vec3 dir)\n{\n    float r = 0.0;\n    vec3 pos = drone.xyz+vec3(3.25, -.48, -8.0);\n    vec3 v = p-pos;\n    vec3 n = vec3(0.0, 1., 0.0);\n    n.zy = rot2D(n.zy, droneRots.z);\n    n = normalize(n);\n    float d = -dot(n, v)/ dot(n, dir);\n    p = p + dir*d-pos;\n\n    if (p.z < .0 && p.z > -20.)\n    {\n        float d = abs(p.z) - abs(p.x)+.4;\n        r = step(.3, d)*.3;\n        r += smoothstep(-.3, -.2,p.x) * smoothstep(0., -.2, p.x)*r;\n        r += smoothstep(.3, .2,p.x) * smoothstep(0.0, .2, p.x)*r;\n        r += smoothstep(0.1, .2, d) * smoothstep(0.4, .2, d);\n    }\n    r += smoothstep(0.3, 0.0,abs(droneRots.z-.4))*1.5;\n\n    return r;\n}\n\n//----------------------------------------------------------------------------------------\nvoid heatHaze(vec3 p, inout vec3 dir, float t)\n{\n    if (t < cueFLYIN) return;\n    float r = 0.0;\n    vec3 pos = vec3(0.0, -4.8, 7.);\n    if (drone.y < 20.0)\n    \tpos.y += smoothstep(-.90, .5,droneRots.y)*smoothstep(.9, 0.5,droneRots.y)*-8.0;\n    pos.zx = rot2D(pos.zx, droneRots.y);\n    pos += drone.xyz;\n    vec3 v = p-pos;\n    vec3 n = vec3(0.0, 0., 1.0);\n\n    n = normalize(n);\n    float d = -dot(n, v)/ dot(n, dir);\n    p = p + dir*d-pos;\n\n    if (p.y < .0 && p.y > -30.)\n    {\n        float l = abs(p.y) - abs(p.x*(1.1))+8.0;\n        r = smoothstep(.0, 14., l);\n        //p.xy *= vec2(.5,.9);\n        t*= 23.0;\n        dir += r*(noise(p.xy*.8+vec2(0.0,t))-.5)*.001/(.07+(smoothstep(10.0, 2500.0, d)*20.0));\n    }\n}\n\n//----------------------------------------------------------------------------------------\nvec3 cameraLookAt(in vec2 uv, in vec3 pos, in vec3 target, in float roll)\n{    \n\tvec3 cw = normalize(target-pos);\n\tvec3 cp = vec3(sin(roll), cos(roll),0.0);\n\tvec3 cu = normalize(cross(cw,cp));\n\tvec3 cv = normalize(cross(cu,cw));\n\treturn normalize(-uv.x*cu + uv.y*cv +2.*cw );\n}\n\n//----------------------------------------------------------------------------------------\nvoid mainImage( out vec4 outColour, in vec2 coords )\n{\n\tvec2 xy = coords.xy / iResolution.xy;\n    vec2 uv = (xy-.5)*vec2( iResolution.x / iResolution.y, 1)*2.0;\n     // Multiply this time to speed up playback, but remember to do the sound as well!\n  \tfloat ti = mod(iTime, 57.);\n    //float ti = mod(iTime, 5.)+cueFRONTOF;\t// ...Test cues..\n    //float ti = mod(iTime, 15.0)+cueTHREAT+1.0;\n    //float ti = mod(iTime, 5.)+cueFLYIN;\n    //float ti = mod(iTime, 5.)+cueFLYOFF;\n\t\n    //---------------------------------------------------------\n    // Animations...\n\tdrone = dronePath(ti);\n    droneRots = droneRotations(ti);\n    vec3 camPos = cameraAni(ti);\n    gunMovement = droneGunAni(ti);\n    float t = smoothstep(cueTHREAT, cueTHREAT+.5, ti) *smoothstep(cueTHREAT+15.5, cueTHREAT+14.7, ti);\n    \n    //float e = -droneRots.y+t*texture(iChannel0, vec2(.3, ti*.02)).x*.25-.22;\n    //e += texture(iChannel0, vec2(.4, ti*.005)).x*.5-.35;\n\tfloat e = 1.0;\n    vec3 eyeCam = normalize(vec3(0.3, -.4*t,  -1.0));\n    eyeCam.xz = rot2D(eyeCam.xz, e);\n    \n\t//---------------------------------------------------------\n\tvec3 tar = dronePath(ti-.25);\n    // Cameraman gets shaky when the drone is close...oh no...\n    float l = 30.0 / length(tar-camPos);\n    tar += (noise3(ti*4.0)-.5)*l;\n    vec3 dir = cameraLookAt(uv, camPos, tar, 0.0);\n\t\n    \n    heatHaze(camPos, dir, ti);\n    //--------------------------------------------------------\n    // Reset and fill the render stack through ray marching...\n    dStack = vec4(-1);\n    eStack = vec4(1000.0);\n    rayMarch(camPos, dir);\n\n    //---------------------------------------------------------\n\t// Use the last stacked value to do the shadow, seems to be OK, phew!...\n    float lg = dStack[0];\n\tvec3 p = camPos + dir * lg;\n    float sha = shadow(p, sunDir);\n    vec3 sky = skyUpper(dir);\n\t//---------------------------------------------------------\n\t// Render the stack...\n    float alphaAcc = .0;\n    vec3 col = vec3(0);\n    float spe;\n    for (int i = 0; i < 4; i++)\n    {\n        float d = dStack[i];\n\t\tif (d > 0.0)\n        {\n            float de = eStack[i];\n            float s = SphereRadius(d);\n            float alpha = max((1.0 - alphaAcc) * min(((s-de) / s), 1.0),0.0);\n\n            vec3 p = camPos + dir * d;\n            vec3  nor = normal(p, s);\n            vec4  mat = mapCE(p, nor);\n            float amb = abs(nor.y)*.6; amb = amb*amb;\n            vec3 c= mat.xyz * vec3(max(dot(sunDir, nor), 0.0))+ amb * mat.xyz;\n            spe = pow(max(dot(sunDir, reflect(dir, nor)), 0.0), 18.0);\n\n            if (emitionType != 0)\n            {\n                if (emitionType == 1)\n                {\n                    s = cos(pow(max(dot(eyeCam, nor), 0.0), 4.4)*9.0)*.14;\n                    s += pow(abs(dot(eyeCam, nor)), 80.)*18.0;\n                    c*= max(s, 0.0);\n                }\n                if (emitionType == 3)\n                {\n                    vec3 dp = p - drone;\n                    s = smoothstep(.0,-.1, nor.y) * smoothstep(-1.0,-.3, nor.y);\n                    c = vec3((smoothstep(-5.8,-5., dp.y) * smoothstep(-4.8,-5., dp.y))*.1);\n                    float g = abs(sin((atan(nor.x, -nor.z))*TAU+ti*33.0))+.2;\n                    //c += s*(texture(iChannel2, p.xy*vec2(.04, .01)+vec2(0.0, ti)).xyy)*vec3(1.5, 2.3,3.5)*g;\n\n                    alpha *= smoothstep(-9.,-4.5, dp.y) - g * smoothstep(-4.5,-10., dp.y)*.2;\n\n                }          \n\n                sha = 1.0;\n            }\n\n            c += sunCol * spe * mat.w;\n\n\n            col += c = fogIt(c *sha, sky, d)* alpha;\n            alphaAcc+= alpha;\n        }\n     }\n    \n\t//---------------------------------------------------------\n    // Back drop...\n    \n    vec3 gro = ground(sky, dir, camPos);\n\t\n    col = mix(col, gro, clamp(1.0-alphaAcc, 0.0, 1.0));\n    \n    \n    if (dStack[0] < 0.0) dStack[0] = 4000.0;\n    col = clouds(col,camPos, dir, dStack[0], ti);\n    \n        // Overlay...\n    float scan = overlay(camPos, dir)*scannerOn;\n\tcol = min(col+vec3(scan*.6, scan*.75, scan), 1.0);\n\n    \n    \n\t//---------------------------------------------------------\n\t// Post effects...\n    col = col*0.5 + 0.5*col*col*(3.0-2.0*col);\t\t\t\t\t// Slight contrast adjust\n    col = sqrt(col);\t\t\t\t\t\t\t\t\t\t\t// Adjust Gamma \n    // I can't decide if I like the added noise or not...\n    //col = clamp(col+hash32(xy+ti)*.11, 0.0, 1.0); \t\t\t\t\t// Random film noise\n\n    \n    col *= .6+0.4*pow(50.0*xy.x*xy.y*(1.0-xy.x)*(1.0-xy.y), 0.2 );\t// Vignette\n    col *= smoothstep(0.0, .5, ti)*smoothstep(58.0, 53., ti);\n\toutColour = vec4(col,1.0);\n}", "user": "8c13546", "parent": null, "id": 47034}