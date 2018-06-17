{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n// playing around with path tracing  :) @owentao\n// inspiration from http://madebyevan.com/webgl-path-tracing/\n// additional bits from @P_Malin's ray marching shaders\n\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\nuniform sampler2D backBuffer;\n\n\n#define EPS 0.0001\n#define INF 100000.0\n#define PI 3.141592654\n\n#define MAT_BOXLEFT 1.0\n#define MAT_BOXRIGHT 2.0\n#define MAT_PLAIN 3.0\n#define MAT_SPHERE 4.0\n#define MAT_NONE 5.0\n\n//not sure how conditional branches perform. premature optimisation blah blah blah...\n// d > 0.0 ? a : b\n#define SELECT(pred, pass, fail) (mix(pass, fail, step(pred, 0.0)))\n//#define SELECT(pred, pass, fail) (pred > 0.0 ? pass : fail)\n\n// d == 0.0 ? a : b\n#define SELECTEQZ(pred, pass, fail) (mix(pass, fail, step(EPS, abs(pred))))\n//#define SELECTEQZ(pred, pass, fail) (abs(pred) < EPS ? pass : fail)\n\n\nfloat random(const in vec3 magnitude, const in float seed) {\n    return fract(sin(dot(gl_FragCoord.xyz + seed, magnitude)) * 54321.6789 + seed);\n}\n\nvec3 cosineSampleHemisphere(const in float seed, const in vec3 normal) {\n    float u = random(vec3(123.456, 789.123, 456.789), seed);\n    float v = random(vec3(654.321, 987.654, 219.876), seed);\n    float r = sqrt(u);\n    float angle = 2.0 * PI * v;\n    \n    vec3 s, t;\n    s = SELECT(abs(normal.x)-0.5, \n            cross(normal, vec3(0.0,1.0,0.0)),\n            cross(normal, vec3(1.0,0.0,0.0)))\n            ;            \n    t = cross(normal, s);\n    return r*cos(angle)*s + r*sin(angle)*t + sqrt(1.-u)*normal;\n}\n\nvec3 uniformSample(const in float seed) {\n    float u = random(vec3(123.456, 789.123, 456.789), seed);\n    float v = random(vec3(654.321, 987.654, 219.876), seed);\n    float z = 1.0 - 2.0 * u;\n    float r = sqrt(1.0 - z * z);\n    float angle = 2.0 * v;\n    return vec3(r*cos(angle), r*sin(angle), z);\n}\n\n\nstruct ray_t {\n    vec3 origin;\n    vec3 direction;\n};\n\nstruct intersect_t {\n    vec3 position;\n    vec3 normal;\n    float surfaceId;\n};\n\nstruct material_t {\n    vec3 albedo;\n    float specular;\n};\n\n\n\n\n\nmaterial_t material(float surfaceId) {\n    vec4 data = vec4(0.0,0.0,0.0, 0.0);\n    \n    data = SELECTEQZ(surfaceId-MAT_SPHERE, vec4(0.8,0.8,0.8, 1.0), data);\n    data = SELECTEQZ(surfaceId-MAT_PLAIN, vec4(0.8,0.8,0.8, 0.01), data);\n    data = SELECTEQZ(surfaceId-MAT_BOXRIGHT, vec4(0.0,0.8,0.0, 0.01), data);\n    data = SELECTEQZ(surfaceId-MAT_BOXLEFT, vec4(0.8,0.0,0.0, 0.01), data);\n    \n    material_t m;\n    m.albedo = data.xyz;\n    m.specular = data.w;\n    return m;\n}\n\n//AABB intersection using slab method\nfloat intersectBox(const in ray_t ray, const in vec3 boxMin, const in vec3 boxMax) {\n    vec3 t1 = (boxMin - ray.origin) / ray.direction;\n    vec3 t2 = (boxMax - ray.origin) / ray.direction;\n\n    float near = max( max( min(t1.x, t2.x), min(t1.y, t2.y)), min(t1.z, t2.z) );\n    float far  = min( min( max(t1.x, t2.x), max(t1.y, t2.y)), max(t1.z, t2.z) );\n    //we're always inside the box, so want the far intersection\n    far = SELECT(far-near, far, INF);\n    return SELECT(far, far, INF);\n}\n\nfloat intersectSphere(const in ray_t ray, const in vec4 sphere) {\n    vec3 v = ray.origin - sphere.xyz;\n\n    float a = dot(ray.direction,ray.direction);\n    float b = 2.0 * dot(v, ray.direction);\n    float c = dot(v,v)-sphere.w*sphere.w;\n    float q = b*b - 4.0*a*c;\n    float qSafe = SELECT(q, q, 0.0); //watch out for <0.0 before attempting the sqrt    \n    float t = (-b-sqrt(qSafe))/(2.0*a);\n    t = SELECT(q, t, INF);\n    return SELECT(t, t, INF);\n}\n\nintersect_t intersectScene(const in ray_t ray) {\n\n    float t=INF;\n    vec4 data = vec4(0.0, 0.0, 0.0, MAT_NONE); //(normal, surfaceId)\n\n    {\n        //test against box\n        const vec3 boxMin = vec3(-1.0, -1.0, -1.0);\n        const vec3 boxMax = vec3(1.0, 1.0, 1.0);\n\n        t = intersectBox(ray, boxMin, boxMax);\n        //work out intersection data\n        vec3 p = ray.origin + t*ray.direction;\n        \n        data = SELECTEQZ(p.x-boxMin.x, vec4(1.0, 0.0, 0.0, MAT_BOXLEFT), data);\n        data = SELECTEQZ(p.x-boxMax.x, vec4(-1.0, 0.0, 0.0, MAT_BOXRIGHT), data);\n        data = SELECTEQZ(p.y-boxMin.y, vec4(0.0, 1.0, 0.0, MAT_PLAIN), data);\n        data = SELECTEQZ(p.y-boxMax.y, vec4(0.0, -1.0, 0.0, MAT_PLAIN), data);\n        data = SELECTEQZ(p.z-boxMin.z, vec4(0.0, 0.0, 1.0, MAT_PLAIN), data);\n        data = SELECTEQZ(p.z-boxMax.z, vec4(0.0, 0.0, -1.0, MAT_PLAIN), data);\n    }\n\n    {\n        //test against sphere\n        vec4 sphere = vec4(-0.1,-0.6,0.1, 0.3);\n        float t1 = intersectSphere(ray, sphere);\n        vec3 p = ray.origin + t1*ray.direction;\n        data = SELECT(t-t1, vec4(normalize(p-sphere.xyz), MAT_SPHERE), data);\n        t = min(t, t1);   \n    }\n\n    intersect_t intersect;\n    intersect.position = ray.origin + t*ray.direction;\n    intersect.normal = data.xyz;\n    intersect.surfaceId = data.w;\n    return intersect;\n}\n\nfloat shadow(const in ray_t ray) {\n    float t = INF;\n    {\n        //test against sphere\n        vec4 sphere = vec4(-0.1,-0.6,0.1, 0.3);\n        float t1 = intersectSphere(ray, sphere);\n        t = min(t, t1);\n    }\n    //assume direction isn't normalised only accept if t < 1.0 (if occluder between ray start and light)\n    return SELECT(t-1.0, 1.0, 0.0);\n}\n\nfloat lambert(const in vec3 lightDir, const in vec3 normal) {\n    return max(0.0, dot(lightDir, normal));\n}\n\nfloat blinnPhong(const in vec3 lightDir, const in vec3 rayDir, const in vec3 normal, const in float specular) {\n    vec3 h = normalize(lightDir - rayDir);\n    float dotNH = max(0.0, dot(h, normal));\n\n    float power = exp2(4.0 + 6.0 * specular);\n    float intensity = 0.125*(power + 2.0);\n\n    return pow(dotNH, power) * intensity;\n}\n\nfloat fresnel(const in vec3 normal, const in vec3 view, const in vec2 reflectance) {\n    float dot1 = dot(normal, -view);\n          dot1 = min(max(1.0-dot1, 0.0), 1.0);\n    float dot2 = dot1*dot1;\n    float dot5 = dot2*dot2*dot1;\n    return reflectance.x + (1.0-reflectance.x) * dot5 * reflectance.y;\n}\n\nvec3 lighting(const in vec3 light, const in vec3 rayDir, const in intersect_t intersect, const material_t material) {\n    vec3 diffuse = vec3(0.0,0.0,0.0);\n    vec3 specular = vec3(0.0,0.0,0.0);\n\n\n    vec3 lightVector = light - intersect.position;\n    vec3 lightDir = normalize(lightVector);\n\n    // shadow ray - NOTE: not normalised!\n    ray_t shadowRay;\n    shadowRay.origin = intersect.position + 0.001*intersect.normal;\n    shadowRay.direction = lightVector;\n    float shadowFactor = shadow(shadowRay);\n\n    float lightDist = length(lightVector);\n    float attenuation = 0.4/lightDist;//(lightDist*lightDist);\n    vec3 lightColour = vec3(0.7,0.7,0.7);\n    diffuse += lightColour * attenuation * shadowFactor * lambert(lightDir, intersect.normal);\n    specular += blinnPhong(lightDir, rayDir, intersect.normal, material.specular);\n    float fresnelTerm = fresnel(intersect.normal, rayDir, vec2(0.1, material.specular));//need to add reflectance to material\n    \n    return mix(diffuse, specular, fresnelTerm);\n}\n\nvec3 trace(in ray_t ray, const in vec3 light) {\n    vec3 colourMask = vec3(1.0);\n    vec3 accumulation = vec3(0.0);\n  \n    for(int bounce = 0; bounce < 4; bounce++) {\n        intersect_t intersect = intersectScene(ray);\n        material_t mat = material(intersect.surfaceId);\n\n        vec3 colour = lighting(light, ray.direction, intersect, mat);\n\n        colourMask *= mat.albedo;\n        accumulation += colourMask * colour;\n\n        ray.origin = intersect.position;\n        ray.direction = cosineSampleHemisphere(time + float(bounce), intersect.normal);\n    }\n    return accumulation;\n}\n\nvec3 cameraRayDir(vec3 pos, vec3 focal, vec3 up)\n{\n    vec2 pixelCoord = gl_FragCoord.xy;\n    vec2 uv = (pixelCoord / resolution.xy);\n    vec2 viewCoord = uv * 2.0 - 1.0;\n\n    viewCoord *= 0.75;\n    float aspect = resolution.x / resolution.y;\n    viewCoord.x *= aspect;                            \n\n    vec3 z = normalize(focal - pos);\n    vec3 x = normalize(cross(z, up));\n    vec3 y = cross(x, z);\n         \n    return normalize(x * viewCoord.x + y * viewCoord.y + z);         \n}\nvec3 orbitPoint( const in float heading, const in float elevation )\n{\n    return vec3(sin(heading) * cos(elevation), sin(elevation), cos(heading) * cos(elevation));\n}\nvoid main() {\n    ray_t ray;\n    ray.origin = vec3(0.0, 0.0, 2.0);\n    //uncomment for mouse - camera control\n    //ray.origin = orbitPoint(PI*(1.5-mouse.x), PI*(0.5+mouse.y))*2.0;\n    ray.direction = cameraRayDir(ray.origin , vec3(0.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0));\n\n    vec3 noise = uniformSample(time);\n    //jitter\n    vec3 light = vec3(0.2, 0.6, -0.7);\n    light += noise*0.04;\n\n    vec3 accumulation = texture2D(backBuffer, gl_FragCoord.xy / resolution.xy).rgb;\n    accumulation = accumulation * accumulation;\n    accumulation += (noise - 0.5) * 1.0/255.0;\n\n    vec3 colour = trace(ray, light);\n    colour = colour / (1.0 + colour);\n\n    vec3 result = mix(colour, accumulation, 0.96);\n    gl_FragColor = vec4(sqrt(result), 1.0);\n}\n", "user": "44256b2", "parent": "/e#1191.1", "id": 47362}