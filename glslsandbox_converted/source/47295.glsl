#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int MAX_MARCHING_STEPS =255;
const float MIN_DIST = 0.0;
const float MAX_DIST = 100.0;
const float EPSILON = .001;




/**
 * Rotation matrix around the X axis.
 */
mat3 rotateX(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
        vec3(1, 0, 0),
        vec3(0, c, -s),
        vec3(0, s, c)
    );
}

/**
 * Rotation matrix around the Y axis.
 */
mat3 rotateY(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
        vec3(c, 0, s),
        vec3(0, 1, 0),
        vec3(-s, 0, c)
    );
}

/**
 * Rotation matrix around the Z axis.
 */
mat3 rotateZ(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
        vec3(c, -s, 0),
        vec3(s, c, 0),
        vec3(0, 0, 1)
    );
}

float smin(float a, float b, float k){
 float h = clamp(.5 + .5*(b-a)/k, .0, 1.);
 return mix(b, a, h) - k*h*(1.-h);
}

float intersectSDF(float a, float b){
 return max(a,b);
}

float unionSDF(float a, float b){
 return min(a,b);
}

float differenceSDF(float a, float b){
 return max(a,-b);
}
float cylinderSDF(vec3 p, float h, float r) {
    // How far inside or outside the cylinder the point is, radially
    float inOutRadius = length(p.xy) - r;
    
    // How far inside or outside the cylinder is, axially aligned with the cylinder
    float inOutHeight = abs(p.z) - h/2.0;
    
    // Assuming p is inside the cylinder, how far is it from the surface?
    // Result will be negative or zero.
    float insideDistance = min(max(inOutRadius, inOutHeight), 0.0);

    // Assuming p is outside the cylinder, how far is it from the surface?
    // Result will be positive or zero.
    float outsideDistance = length(max(vec2(inOutRadius, inOutHeight), 0.0));
    
    return insideDistance + outsideDistance;
}
float sphereSDF(vec3 p, float radi){
 return length(p) - radi;
}

float cubeSDF(vec3 p, float side){
 vec3 d = abs(p) - vec3(side,side,side);
 
 float inside = min(max(d.x, max(d.y, d.z)), 0.0);
 float outside = length(max(d, 0.0));
  
 return inside + outside;
}

float capsuleSDF( vec3 p, vec3 a, vec3 b, float r )
{
    vec3 pa = p - a, ba = b - a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return length( pa - ba*h ) - r;
}

float tetrahedronSDF(vec3 p){
 vec3 v1 = vec3(1.,1.,1.);
 vec3 v2 = vec3(1.,-1.,-1.);
 vec3 v3 = vec3(-1.,1.,-1.);
 vec3 v4 = vec3(-1.,-1.,1.);   
 float a;
 a = capsuleSDF(p, v1, v2, 0.12);
 a = unionSDF(a, capsuleSDF(p, v1, v3, 0.12));
 a = unionSDF(a, capsuleSDF(p, v1, v4, 0.12));
 a = unionSDF(a, capsuleSDF(p, v2, v3, 0.12));
 a = unionSDF(a, capsuleSDF(p, v2, v4, 0.12));
 a = unionSDF(a, capsuleSDF(p, v3, v4, 0.12));
 return a;

}

float sceneSDF(vec3 p){

 
 float radi = 0.4; 
 
 float sphere = cubeSDF(p, 0.4);
 sphere = unionSDF(sphere, sphereSDF(p, 0.4));
 sphere = unionSDF(sphere, sphereSDF(p, 0.4));
 sphere = unionSDF(sphere, sphereSDF(p, 0.4));
 p = rotateY(time)*p;
 float s = sphereSDF(p, radi);
 //kub = smin(kub, sphere,3.6);
 return smin(sphere,tetrahedronSDF(p), 0.2);//unionSDF(kub,capsuleSDF(p, v1, v2, 0.12));
}


float shortestDistanceToSurface(vec3 eye, vec3 marchDir, float start, float end){
 float depth = start;
 for(int i = 0; i < MAX_MARCHING_STEPS; i++){
  float dist = sceneSDF(eye + depth * marchDir);
  if(dist < EPSILON){
   return depth;
  }
  depth += dist;
  if(depth >= end){
   return end;
  }
 }
 return end;
}

vec3 rayDirection(float fov, vec2 size, vec2 fragCoord){
 vec2 xy = fragCoord - size/2.0;
 float z  = size.y / tan(radians(fov) / 2.0);
 return normalize(vec3(xy, -z));
}

vec3 estimateNormal(vec3 p){
 return normalize(vec3(
  sceneSDF(vec3(p.x + EPSILON, p.y, p.z)) - sceneSDF(vec3(p.x - EPSILON, p.y, p.z)),
  sceneSDF(vec3(p.x, p.y + EPSILON, p.z)) - sceneSDF(vec3(p.x, p.y - EPSILON, p.z)),
  sceneSDF(vec3(p.x, p.y, p.z + EPSILON)) - sceneSDF(vec3(p.x, p.y, p.z - EPSILON))
 ));
}

/**
 * Lighting contribution of a single point light source via Phong illumination.
 * 
 * The vec3 returned is the RGB color of the light's contribution.
 *
 * k_a: Ambient color
 * k_d: Diffuse color
 * k_s: Specular color
 * alpha: Shininess coefficient
 * p: position of point being lit
 * eye: the position of the camera
 * lightPos: the position of the light
 * lightIntensity: color/intensity of the light
 *
 * See https://en.wikipedia.org/wiki/Phong_reflection_model#Description
 */
vec3 phongContribForLight(vec3 k_d, vec3 k_s, float alpha, vec3 p, vec3 eye,
                          vec3 lightPos, vec3 lightIntensity) {
    vec3 N = estimateNormal(p);
    vec3 L = normalize(lightPos - p);
    vec3 V = normalize(eye - p);
    vec3 R = normalize(reflect(-L, N));
    
    float dotLN = dot(L, N);
    float dotRV = dot(R, V);
    
    if (dotLN < 0.0) {
        // Light not visible from this point on the surface
        return vec3(0.0, 0.0, 0.0);
    } 
    
    if (dotRV < 0.0) {
        // Light reflection in opposite direction as viewer, apply only diffuse
        // component
        return lightIntensity * (k_d * dotLN);
    }
    return lightIntensity * (k_d * dotLN + k_s * pow(dotRV, alpha));
}

/**
 * Lighting via Phong illumination.
 * 
 * The vec3 returned is the RGB color of that point after lighting is applied.
 * k_a: Ambient color
 * k_d: Diffuse color
 * k_s: Specular color
 * alpha: Shininess coefficient
 * p: position of point being lit
 * eye: the position of the camera
 *
 * See https://en.wikipedia.org/wiki/Phong_reflection_model#Description
 */
vec3 phongIllumination(vec3 k_a, vec3 k_d, vec3 k_s, float alpha, vec3 p, vec3 eye) {
    const vec3 ambientLight = 0.5 * vec3(1.0, 1.0, 1.0);
    vec3 color = ambientLight * k_a;
    
    vec3 light1Pos = vec3(4.0 * sin(time),
                          2.0,
                          4.0 * cos(time));
    vec3 light1Intensity = vec3(0.4, 0.4, 0.4);
    
    color += phongContribForLight(k_d, k_s, alpha, p, eye,
                                  light1Pos,
                                  light1Intensity);
    
    vec3 light2Pos = vec3(2.0 * sin(0.37 * time),
                          2.0 * cos(0.37 * time),
                          2.0);
    vec3 light2Intensity = vec3(0.4, 0.4, 0.4);
    
    color += phongContribForLight(k_d, k_s, alpha, p, eye,
                                  light2Pos,
                                  light2Intensity);    
    return color;
}

mat4 viewMatrix(vec3 eye, vec3 center, vec3 up) {
 vec3 f = normalize(center - eye);
 vec3 s = normalize(cross(f, up));
 vec3 u = cross(s, f);
 return mat4(
  vec4(s, 0.0),
  vec4(u, 0.0),
  vec4(-f, 0.0),
  vec4(0.0, 0.0, 0.0, 1)
 );
}

void main( void ) {

 vec3 viewDir = rayDirection(45.0, resolution.xy, gl_FragCoord.xy);
 vec3 eye = vec3(8.0,5.0,7.0);
 
 mat4 viewToWorld = viewMatrix(eye, vec3(0.,0.,0.), vec3(0.,1.,0.));
 
 vec3 worldDir = (viewToWorld * vec4(viewDir, 0.)).xyz;
 
 float dist = shortestDistanceToSurface(eye, worldDir, MIN_DIST, MAX_DIST);
 
 if(dist > MAX_DIST - EPSILON){
  gl_FragColor = vec4(0.0,0.0,0.0,1.0); 
  return;
 } else if(dist < 11.){
  gl_FragColor=vec4(0.0,0.0,.0,1.);
  return;
 }
 // The closest point on the surface to the eyepoint along the view ray
 vec3 p = eye + dist * worldDir;
 vec3 K_a = vec3(0.2, 0.2, 0.2);
 vec3 K_d = vec3(0.7, 0.2, 0.2);
 vec3 K_s = vec3(1.0, 1.0, 1.0);
 float shininess = 10.0;
     
 vec3 color = phongIllumination(K_a, K_d, K_s, shininess, p, eye);
 gl_FragColor = vec4(color,1.0);

}