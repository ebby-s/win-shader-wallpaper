{"code": "/*\n * Original shader from: https://www.shadertoy.com/view/Xt2XDh\n */\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n// glslsandbox uniforms\nuniform float time;\nuniform vec2 resolution;\nuniform vec2 mouse;\n\n// shadertoy globals\nfloat iTime;\nvec3  iResolution;\nvec3  iMouse;\n\n// Protect glslsandbox uniform names\n#define time        stemu_time\n#define resolution  stemu_resolution\n#define mouse       stemu_mouse\n\n// --------[ Original ShaderToy begins here ]---------- //\n//Raymarch settings\n\n#define MIN_DIST 0.004\n#define MAX_DIST 16.0\n#define MAX_STEPS 48\n#define STEP_MULT 1.0\n#define NORMAL_OFFS 0.02\n\n//Scene settings\n#define HAZE_COLOR vec3(0.0, 0.1, 0.2)\n\n//Show the number of steps taken by each ray, (green ~= 0, red ~= MAXSTEPS)\n//#define SHOW_RAY_COST\n\n//if the current distance is far from an object, use an approximate distance.\n//Boosts the framerate from ~30fps to 60fps in fullscreen on my machine.\n#define APPROX_FAR_DIST\n\nfloat pi = atan(1.0) * 4.0;\nfloat tau = atan(1.0) * 8.0;\n\nstruct MarchResult\n{\n    vec3 position;\n    vec3 normal;\n    float dist;\n    float steps;\n};\n\n//Returns a rotation matrix for the given angles around the X,Y,Z axes.\nmat3 Rotate(vec3 angles)\n{\n    vec3 c = cos(angles);\n    vec3 s = sin(angles);\n    \n    mat3 rotX = mat3( 1.0, 0.0, 0.0, 0.0,c.x,s.x, 0.0,-s.x, c.x);\n    mat3 rotY = mat3( c.y, 0.0,-s.y, 0.0,1.0,0.0, s.y, 0.0, c.y);\n    mat3 rotZ = mat3( c.z, s.z, 0.0,-s.z,c.z,0.0, 0.0, 0.0, 1.0);\n\n    return rotX * rotY * rotZ;\n}\n\n//==== Distance field operators/functions by iq. ====\nfloat opU( float d1, float d2 )\n{\n    return min(d1,d2);\n}\n\nfloat opS( float d1, float d2 )\n{\n    return max(-d1, d2);\n}\n\nfloat opI( float d1, float d2 )\n{\n    return max(d1,d2);\n}\n\n//polynomial smooth minimum\nfloat opSU( float a, float b, float k )\n{\n    float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );\n    return mix( b, a, h ) - k*h*(1.0-h);\n}\n\nvec3 opAngRep( vec3 p, float a )\n{\n\tvec2 polar = vec2(atan(p.y, p.x), length(p.xy));\n    polar.x = mod(polar.x + a / 2.0, a) - a / 2.0;\n    \n    return vec3(polar.y * vec2(cos(polar.x),sin(polar.x)), p.z);\n}\n\nfloat sdSphere( vec3 p, float s )\n{\n  return length(p) - s;\n}\n\nfloat sdPlane( vec3 p, vec4 n )\n{\n  return dot(p, normalize(n.xyz)) + n.w;\n}\n\nfloat sdCylinder( vec3 p, vec2 s)\n{\n    return max(abs(p.z) - s.y / 2.0,length(p.xy) - s.x);\n}\n\nfloat sdPole( vec3 p, float s)\n{\n    return length(p.xy) - s;\n}\n\nfloat sdBox( vec3 p, vec3 s )\n{\n    p = abs(p) - s / 2.0;\n    return max(max(p.x,p.y),p.z);\n}\n//===================================================\n\n//16 tooth gear\nfloat dfGear16(vec3 p)\n{\n    float gear = sdCylinder(p , vec2(1.0,0.35));\n    \n    //Teeth\n    vec3 rep = opAngRep(p, tau / 16.0);\n    \n    float tooth = opI(sdCylinder(rep - vec3(1.0,0.4,0), vec2(0.5,0.25)), sdCylinder(rep - vec3(1.0,-0.4,0), vec2(0.5,0.25)));\n    tooth = opS(-sdCylinder(p,vec2(1.2,2.0)), tooth);\n    \n    gear = opU(gear, tooth);\n    \n    //Inner ring\n    gear = opS(sdCylinder(p , vec2(0.8,0.5)), gear);\n    \n    gear = opU(gear, sdCylinder(p , vec2(0.3,0.35)));\n    \n    //Spokes\n    vec3 rep2 = opAngRep(p, tau / 6.0);\n    \n    gear = opSU(gear, sdBox(rep2, vec3(1.5,0.2,0.1)),0.1);\n    \n    return gear;\n}\n\n//simplified 16 tooth gear (for border area)\nfloat dfGear16s(vec3 p)\n{  \n    vec3 rep = opAngRep(p, tau / 16.0);\n    \n    float tooth = opI(sdCylinder(rep - vec3(1.0,0.4,0), vec2(0.5,0.25)), sdCylinder(rep - vec3(1.0,-0.4,0), vec2(0.5,0.25)));\n    tooth = opS(-sdCylinder(p,vec2(1.2,2.0)), tooth);\n    \n    return tooth;\n}\n\nmat3 rot1 = mat3(0);\nmat3 rot2 = mat3(0);\n\n//Distance to the scene\nfloat Scene(vec3 p)\n{\n    float d = -sdSphere(p, MAX_DIST);\n    \n    d = opU(d, sdPlane(p , vec4(0,0,-1,2)));\n    \n    vec3 pr = mod(p + 1.1, vec3(2.2)) - 1.1;\n    \n    //Checkerboard based gear rotation direction\n    float di = step(0.0,cos(pi*p.x/2.2) * cos(pi*p.y/2.2));\n    \n    mat3 r1;\n    mat3 r2;\n    \n    if(di > 0.0)\n    {\n    \tr1 = rot1;\n        r2 = rot2;\n    }\n    else\n    {\n    \tr1 = rot2;\n        r2 = rot1;\n    }\n    \n    #ifdef APPROX_FAR_DIST\n    if(sdCylinder(pr , vec2(1.5,0.45)) < 0.0)\n    {\n        //Center gear\n        d = opU(d, dfGear16((pr - vec3( 0.0, 0.0, 0.0)) * r1));\n\n        //Border gears\n        d = opU(d, dfGear16s((pr - vec3(-2.2, 0.0, 0.0)) * r2));\n        d = opU(d, dfGear16s((pr - vec3( 2.2, 0.0, 0.0)) * r2));\n        d = opU(d, dfGear16s((pr - vec3( 0.0,-2.2, 0.0)) * r2));\n        d = opU(d, dfGear16s((pr - vec3( 0.0, 2.2, 0.0)) * r2));\n    }\n    else\n    {\n    \td = opU(d, sdCylinder(pr , vec2(1.25,0.35)));\n    }\n    \n    #else   \n    //Center gear\n    d = opU(d, dfGear16((pr - vec3( 0.0, 0.0, 0.0)) * r1));\n\n    //Border gears\n    d = opU(d, dfGear16s((pr - vec3(-2.2, 0.0, 0.0)) * r2));\n    d = opU(d, dfGear16s((pr - vec3( 2.2, 0.0, 0.0)) * r2));\n    d = opU(d, dfGear16s((pr - vec3( 0.0,-2.2, 0.0)) * r2));\n    d = opU(d, dfGear16s((pr - vec3( 0.0, 2.2, 0.0)) * r2));   \n    #endif\n    \n    \n        //Shafts and supports\n    d = opU(d, sdPole(pr, 0.15));\n    d = opU(d, sdPole(pr.zxy - vec3(0.5,0.0,0.0), 0.15));\n    d = opU(d, sdPole(pr.zyx - vec3(0.5,0.0,0.0), 0.15));\n    d = opU(d, sdCylinder(pr - vec3(0,0,0.5), vec2(0.25,0.4)));\n    \n\treturn d;\n}\n\n\n//Surface normal at the current position\nvec3 Normal(vec3 p)\n{\n    vec3 off = vec3(NORMAL_OFFS, 0, 0);\n    return normalize\n    ( \n        vec3\n        (\n            Scene(p + off.xyz) - Scene(p - off.xyz),\n            Scene(p + off.zxy) - Scene(p - off.zxy),\n            Scene(p + off.yzx) - Scene(p - off.yzx)\n        )\n    );\n}\n\n//Raymarch the scene with the given ray\nMarchResult MarchRay(vec3 orig,vec3 dir)\n{\n    float steps = 0.0;\n    float dist = 0.0;\n    \n    for(int i = 0;i < MAX_STEPS;i++)\n    {\n        float sceneDist = Scene(orig + dir * dist);\n        \n        dist += sceneDist * STEP_MULT;\n        \n        steps++;\n        \n        if(abs(sceneDist) < MIN_DIST)\n        {\n            break;\n        }\n    }\n    \n    MarchResult result;\n    \n    result.position = orig + dir * dist;\n    result.normal = Normal(result.position);\n    result.dist = dist;\n    result.steps = steps;\n    \n    return result;\n}\n\n//Scene texturing/shading\nvec3 Shade(MarchResult hit, vec3 direction, vec3 camera)\n{\n    vec3 color = vec3(0.7);\n    \n    //Lighting\n    float ambient = 0.1;\n    float diffuse = 0.4 * -dot(hit.normal, direction);\n    float specular = 1.0 * max(0.0, -dot(direction, reflect(direction, hit.normal)));\n    \n    color *= vec3(ambient + diffuse + pow(specular, 8.0));\n\t\n    //Fog / haze\n    float sky = smoothstep(MAX_DIST - 1.0, 0.0, length(hit.position));\n    float haze = 1.0 - (hit.steps / float(MAX_STEPS));\n    \n    vec3 skycol = mix(HAZE_COLOR, vec3(0), clamp(-hit.position.z * 0.2, 0.0, 1.0));\n    \n    color = mix(skycol, color, sky * haze);\n    \n    return color;\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n    vec2 res = iResolution.xy / iResolution.y;\n\tvec2 uv = fragCoord.xy / iResolution.y;\n    \n    rot1 = Rotate(vec3(0,0,iTime));\n    rot2 = Rotate(vec3(0,0,-iTime - tau/32.0));\n    \n    //Camera stuff   \n    vec3 angles = vec3(0);\n    \n    if(iMouse.z < 1.0)\n    {\n        angles.y = tau * (1.5 / 8.0);\n        angles.x = iTime *-0.2;\n    }\n    else\n    {    \n    \tangles = vec3((iMouse.xy / iResolution.xy) * pi, 0);\n        angles.xy *= vec2(2.0, 1.0);\n    }\n    \n    angles.y = clamp(angles.y, 0.0, tau / 4.0);\n    \n    mat3 rotate = Rotate(angles.yzx);\n    \n    vec3 orig = vec3(0, 0,-3) * rotate;\n    orig -= vec3(0, 0, 0);\n    \n    vec3 dir = normalize(vec3(uv - res / 2.0, 0.5)) * rotate;\n    \n    //Ray marching\n    MarchResult hit = MarchRay(orig, dir);\n    \n    //Shading\n    vec3 color = Shade(hit, dir, orig);\n    \n    #ifdef SHOW_RAY_COST\n    color = mix(vec3(0,1,0), vec3(1,0,0), hit.steps / float(MAX_STEPS));\n    #endif\n    \n\tfragColor = vec4(color, 1.0);\n}\n// --------[ Original ShaderToy ends here ]---------- //\n\n#undef time\n#undef resolution\n#undef mouse\n\nvoid main(void)\n{\n  iTime = time;\n  iResolution = vec3(resolution, 0.0);\n  iMouse = vec3(mouse * resolution, 0.0);\n\n  mainImage(gl_FragColor, gl_FragCoord.xy);\n}", "user": "23293a6", "parent": null, "id": "45631.0"}