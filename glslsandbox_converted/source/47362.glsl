#ifdef GL_ES
precision mediump float;
#endif

// playing around with path tracing  :) @owentao
// inspiration from http://madebyevan.com/webgl-path-tracing/
// additional bits from @P_Malin's ray marching shaders


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backBuffer;


#define EPS 0.0001
#define INF 100000.0
#define PI 3.141592654

#define MAT_BOXLEFT 1.0
#define MAT_BOXRIGHT 2.0
#define MAT_PLAIN 3.0
#define MAT_SPHERE 4.0
#define MAT_NONE 5.0

//not sure how conditional branches perform. premature optimisation blah blah blah...
// d > 0.0 ? a : b
#define SELECT(pred, pass, fail) (mix(pass, fail, step(pred, 0.0)))
//#define SELECT(pred, pass, fail) (pred > 0.0 ? pass : fail)

// d == 0.0 ? a : b
#define SELECTEQZ(pred, pass, fail) (mix(pass, fail, step(EPS, abs(pred))))
//#define SELECTEQZ(pred, pass, fail) (abs(pred) < EPS ? pass : fail)


float random(const in vec3 magnitude, const in float seed) {
    return fract(sin(dot(gl_FragCoord.xyz + seed, magnitude)) * 54321.6789 + seed);
}

vec3 cosineSampleHemisphere(const in float seed, const in vec3 normal) {
    float u = random(vec3(123.456, 789.123, 456.789), seed);
    float v = random(vec3(654.321, 987.654, 219.876), seed);
    float r = sqrt(u);
    float angle = 2.0 * PI * v;
    
    vec3 s, t;
    s = SELECT(abs(normal.x)-0.5, 
            cross(normal, vec3(0.0,1.0,0.0)),
            cross(normal, vec3(1.0,0.0,0.0)))
            ;            
    t = cross(normal, s);
    return r*cos(angle)*s + r*sin(angle)*t + sqrt(1.-u)*normal;
}

vec3 uniformSample(const in float seed) {
    float u = random(vec3(123.456, 789.123, 456.789), seed);
    float v = random(vec3(654.321, 987.654, 219.876), seed);
    float z = 1.0 - 2.0 * u;
    float r = sqrt(1.0 - z * z);
    float angle = 2.0 * v;
    return vec3(r*cos(angle), r*sin(angle), z);
}


struct ray_t {
    vec3 origin;
    vec3 direction;
};

struct intersect_t {
    vec3 position;
    vec3 normal;
    float surfaceId;
};

struct material_t {
    vec3 albedo;
    float specular;
};





material_t material(float surfaceId) {
    vec4 data = vec4(0.0,0.0,0.0, 0.0);
    
    data = SELECTEQZ(surfaceId-MAT_SPHERE, vec4(0.8,0.8,0.8, 1.0), data);
    data = SELECTEQZ(surfaceId-MAT_PLAIN, vec4(0.8,0.8,0.8, 0.01), data);
    data = SELECTEQZ(surfaceId-MAT_BOXRIGHT, vec4(0.0,0.8,0.0, 0.01), data);
    data = SELECTEQZ(surfaceId-MAT_BOXLEFT, vec4(0.8,0.0,0.0, 0.01), data);
    
    material_t m;
    m.albedo = data.xyz;
    m.specular = data.w;
    return m;
}

//AABB intersection using slab method
float intersectBox(const in ray_t ray, const in vec3 boxMin, const in vec3 boxMax) {
    vec3 t1 = (boxMin - ray.origin) / ray.direction;
    vec3 t2 = (boxMax - ray.origin) / ray.direction;

    float near = max( max( min(t1.x, t2.x), min(t1.y, t2.y)), min(t1.z, t2.z) );
    float far  = min( min( max(t1.x, t2.x), max(t1.y, t2.y)), max(t1.z, t2.z) );
    //we're always inside the box, so want the far intersection
    far = SELECT(far-near, far, INF);
    return SELECT(far, far, INF);
}

float intersectSphere(const in ray_t ray, const in vec4 sphere) {
    vec3 v = ray.origin - sphere.xyz;

    float a = dot(ray.direction,ray.direction);
    float b = 2.0 * dot(v, ray.direction);
    float c = dot(v,v)-sphere.w*sphere.w;
    float q = b*b - 4.0*a*c;
    float qSafe = SELECT(q, q, 0.0); //watch out for <0.0 before attempting the sqrt    
    float t = (-b-sqrt(qSafe))/(2.0*a);
    t = SELECT(q, t, INF);
    return SELECT(t, t, INF);
}

intersect_t intersectScene(const in ray_t ray) {

    float t=INF;
    vec4 data = vec4(0.0, 0.0, 0.0, MAT_NONE); //(normal, surfaceId)

    {
        //test against box
        const vec3 boxMin = vec3(-1.0, -1.0, -1.0);
        const vec3 boxMax = vec3(1.0, 1.0, 1.0);

        t = intersectBox(ray, boxMin, boxMax);
        //work out intersection data
        vec3 p = ray.origin + t*ray.direction;
        
        data = SELECTEQZ(p.x-boxMin.x, vec4(1.0, 0.0, 0.0, MAT_BOXLEFT), data);
        data = SELECTEQZ(p.x-boxMax.x, vec4(-1.0, 0.0, 0.0, MAT_BOXRIGHT), data);
        data = SELECTEQZ(p.y-boxMin.y, vec4(0.0, 1.0, 0.0, MAT_PLAIN), data);
        data = SELECTEQZ(p.y-boxMax.y, vec4(0.0, -1.0, 0.0, MAT_PLAIN), data);
        data = SELECTEQZ(p.z-boxMin.z, vec4(0.0, 0.0, 1.0, MAT_PLAIN), data);
        data = SELECTEQZ(p.z-boxMax.z, vec4(0.0, 0.0, -1.0, MAT_PLAIN), data);
    }

    {
        //test against sphere
        vec4 sphere = vec4(-0.1,-0.6,0.1, 0.3);
        float t1 = intersectSphere(ray, sphere);
        vec3 p = ray.origin + t1*ray.direction;
        data = SELECT(t-t1, vec4(normalize(p-sphere.xyz), MAT_SPHERE), data);
        t = min(t, t1);   
    }

    intersect_t intersect;
    intersect.position = ray.origin + t*ray.direction;
    intersect.normal = data.xyz;
    intersect.surfaceId = data.w;
    return intersect;
}

float shadow(const in ray_t ray) {
    float t = INF;
    {
        //test against sphere
        vec4 sphere = vec4(-0.1,-0.6,0.1, 0.3);
        float t1 = intersectSphere(ray, sphere);
        t = min(t, t1);
    }
    //assume direction isn't normalised only accept if t < 1.0 (if occluder between ray start and light)
    return SELECT(t-1.0, 1.0, 0.0);
}

float lambert(const in vec3 lightDir, const in vec3 normal) {
    return max(0.0, dot(lightDir, normal));
}

float blinnPhong(const in vec3 lightDir, const in vec3 rayDir, const in vec3 normal, const in float specular) {
    vec3 h = normalize(lightDir - rayDir);
    float dotNH = max(0.0, dot(h, normal));

    float power = exp2(4.0 + 6.0 * specular);
    float intensity = 0.125*(power + 2.0);

    return pow(dotNH, power) * intensity;
}

float fresnel(const in vec3 normal, const in vec3 view, const in vec2 reflectance) {
    float dot1 = dot(normal, -view);
          dot1 = min(max(1.0-dot1, 0.0), 1.0);
    float dot2 = dot1*dot1;
    float dot5 = dot2*dot2*dot1;
    return reflectance.x + (1.0-reflectance.x) * dot5 * reflectance.y;
}

vec3 lighting(const in vec3 light, const in vec3 rayDir, const in intersect_t intersect, const material_t material) {
    vec3 diffuse = vec3(0.0,0.0,0.0);
    vec3 specular = vec3(0.0,0.0,0.0);


    vec3 lightVector = light - intersect.position;
    vec3 lightDir = normalize(lightVector);

    // shadow ray - NOTE: not normalised!
    ray_t shadowRay;
    shadowRay.origin = intersect.position + 0.001*intersect.normal;
    shadowRay.direction = lightVector;
    float shadowFactor = shadow(shadowRay);

    float lightDist = length(lightVector);
    float attenuation = 0.4/lightDist;//(lightDist*lightDist);
    vec3 lightColour = vec3(0.7,0.7,0.7);
    diffuse += lightColour * attenuation * shadowFactor * lambert(lightDir, intersect.normal);
    specular += blinnPhong(lightDir, rayDir, intersect.normal, material.specular);
    float fresnelTerm = fresnel(intersect.normal, rayDir, vec2(0.1, material.specular));//need to add reflectance to material
    
    return mix(diffuse, specular, fresnelTerm);
}

vec3 trace(in ray_t ray, const in vec3 light) {
    vec3 colourMask = vec3(1.0);
    vec3 accumulation = vec3(0.0);
  
    for(int bounce = 0; bounce < 4; bounce++) {
        intersect_t intersect = intersectScene(ray);
        material_t mat = material(intersect.surfaceId);

        vec3 colour = lighting(light, ray.direction, intersect, mat);

        colourMask *= mat.albedo;
        accumulation += colourMask * colour;

        ray.origin = intersect.position;
        ray.direction = cosineSampleHemisphere(time + float(bounce), intersect.normal);
    }
    return accumulation;
}

vec3 cameraRayDir(vec3 pos, vec3 focal, vec3 up)
{
    vec2 pixelCoord = gl_FragCoord.xy;
    vec2 uv = (pixelCoord / resolution.xy);
    vec2 viewCoord = uv * 2.0 - 1.0;

    viewCoord *= 0.75;
    float aspect = resolution.x / resolution.y;
    viewCoord.x *= aspect;                            

    vec3 z = normalize(focal - pos);
    vec3 x = normalize(cross(z, up));
    vec3 y = cross(x, z);
         
    return normalize(x * viewCoord.x + y * viewCoord.y + z);         
}
vec3 orbitPoint( const in float heading, const in float elevation )
{
    return vec3(sin(heading) * cos(elevation), sin(elevation), cos(heading) * cos(elevation));
}
void main() {
    ray_t ray;
    ray.origin = vec3(0.0, 0.0, 2.0);
    //uncomment for mouse - camera control
    //ray.origin = orbitPoint(PI*(1.5-mouse.x), PI*(0.5+mouse.y))*2.0;
    ray.direction = cameraRayDir(ray.origin , vec3(0.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0));

    vec3 noise = uniformSample(time);
    //jitter
    vec3 light = vec3(0.2, 0.6, -0.7);
    light += noise*0.04;

    vec3 accumulation = texture2D(backBuffer, gl_FragCoord.xy / resolution.xy).rgb;
    accumulation = accumulation * accumulation;
    accumulation += (noise - 0.5) * 1.0/255.0;

    vec3 colour = trace(ray, light);
    colour = colour / (1.0 + colour);

    vec3 result = mix(colour, accumulation, 0.96);
    gl_FragColor = vec4(sqrt(result), 1.0);
}
