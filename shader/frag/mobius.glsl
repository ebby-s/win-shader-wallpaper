#version 120

/*
    Complex operations
*/

vec2 C_Conj(vec2 z)
{
    return vec2(z.x, -z.y);
}

vec2 C_Mult(vec2 z, vec2 w)
{
    return vec2(z.x * w.x - z.y * w.y, z.x * w.y + z.y * w.x);
}

float C_MagSquared(vec2 z)
{
    return z.x * z.x + z.y * z.y;
}

vec2 C_Div(vec2 z, vec2 w)
{
    return C_Mult(z, C_Conj(w)) / C_MagSquared(w);
}

vec2 C_Inv(vec2 z)
{
    return C_Conj(z) / C_MagSquared(z);
}

vec2 C_Sqrt(vec2 z)
{
    float r2 = C_MagSquared(z);
    float r = sqrt(sqrt(r2));
    float angle = atan(z.y, z.x);
    return r * vec2(cos(angle / 2.0), sin(angle / 2.0));
}


/*
    Quaternion operations
*/

float Q_MagSquared(vec4 q)
{
    return dot(q, q);
}

vec4 Q_Mult(vec4 p, vec4 q)
{
    return vec4(p.x * q.x - dot(p.yzw, q.yzw),
                p.x * q.yzw + q.x * p.yzw + cross(p.yzw, q.yzw));
}

vec4 Q_Div(vec4 p, vec4 q)
{
    float mag = Q_MagSquared(q);
    vec4 q_inv = vec4(q.x, -q.yzw) / mag;
    return Q_Mult(p, q_inv);
}


/*
    Mobius transformations
*/

struct Mobius
{
    vec2 A;
    vec2 B;
    vec2 C;
    vec2 D;
};

Mobius M_Scale(Mobius m, vec2 s)
{
    Mobius result;
    result.A = C_Mult(m.A, s);
    result.B = C_Mult(m.B, s);
    result.C = C_Mult(m.C, s);
    result.D = C_Mult(m.D, s);
    return result;
}

Mobius M_Normalize(Mobius m)
{
    vec2 k = C_Inv(C_Sqrt(m.A * m.D - m.B * m.C));
    return M_Scale(m, k);
}

Mobius M_Mult(Mobius a, Mobius b)
{
    Mobius result;
    result.A = C_Mult(a.A, b.A) + C_Mult(a.B, b.C);
    result.B = C_Mult(a.A, b.B) + C_Mult(a.B, b.D);
    result.C = C_Mult(a.C, b.A) + C_Mult(a.D, b.C);
    result.D = C_Mult(a.C, b.B) + C_Mult(a.D, b.D);
    return M_Normalize(result);
}

vec2 M_Apply(Mobius m, vec2 z)
{
    return C_Div(C_Mult(m.A, z) + m.B, C_Mult(m.C, z) + m.D);
}

vec4 M_Apply(Mobius m, vec4 q)
{
    vec4 a = vec4(m.A, 0.0, 0.0);
    vec4 b = vec4(m.B, 0.0, 0.0);
    vec4 c = vec4(m.C, 0.0, 0.0);
    vec4 d = vec4(m.D, 0.0, 0.0);
    return Q_Div(Q_Mult(a, q) + b, Q_Mult(c, q) + d);
}


/*
    Convert between Euclidean distance and
    hyperbolic distance in upper halfspace
*/

# define e_ 2.71828182846

float UHStoH(float e)
{
    return log(e);
}

float HtoUHS(float h)
{
    return pow(e_, h);
}


/*
    Rotation in the 2D plane
*/

vec2 Rotate2d(vec2 p, float t)
{
    return vec2(p.x * cos(t) - p.y * sin(t),
                p.y * cos(t) + p.x * sin(t));
}


/*
    1d and 2d grid
*/

void Mod(inout float x, float size)
{
    x = mod(x + 0.5 * size, size) - 0.5 * size;
}

void Mod2d(inout vec2 p, vec2 size)
{
    p = mod(p + 0.5 * size, size) - 0.5 * size;
}


/*
    Spherical grid in two dimensions
*/

void Mod2dPolar(inout vec2 p, vec2 size)
{
    float phase = atan(p.y, p.x);
    float modulus = UHStoH(length(p));
    Mod(phase, size.y);
    Mod(modulus, size.x);
    p = vec2(modulus, phase);
}


#define PI 3.141592653
#define TWOPI (2 * PI)

/*
  Convert hsv color to rgb color
*/

vec3 hsv2rgb(vec3 hsv)
{
    const vec3 p = vec3(0.0, 2.0/3.0, 1.0/3.0);
    hsv.yz = clamp(hsv.yz, 0.0, 1.0);
    return hsv.z * (0.63 * hsv.y * (cos(TWOPI *(hsv.x + p)) - 1.0) + 1.0);
}


/*
  Transform objects in view space to model space
*/

mat3 viewMatrix(vec3 eye, vec3 lookat, vec3 up)
{
    vec3 f = normalize(lookat - eye);
    vec3 r = normalize(cross(f, up));
    vec3 u = normalize(cross(r, f));
    return mat3(r, u, -f);
}


/*
    Get ray directions
*/

vec3 rayDirection(float fov, vec2 size, vec2 fragCoord) {
    vec2 xy = fragCoord - size / 2.0;
    float z = size.y / tan(radians(fov) / 2.0);
    return normalize(vec3(xy, -z));
}


/*
    Constructive solid geometry union operation on SDF-calculated distances.
*/

float unionSDF(float distA, float distB) {
    return min(distA, distB);
}


/*
  Signed distance function for a sphere kissing the origin with radius r.
*/

float sphereSdf(vec3 p, float r)
{
    p.z -= r;
    return length(p) - r;
}


/*
  Signed distance functions for the z=0 and z=c planes
*/

float planeSdf(vec3 p)
{
    return length(p.z);
}

float planeSdf(vec3 p, float planeOffset)
{
    return length(p.z) - planeOffset;
}


// ACES tone mapping
// https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve/
vec3 tonemap(vec3 color)
{
   const float A = 2.51;
   const float B = 0.03;
   const float C = 2.43;
   const float D = 0.59;
   const float E = 0.14;
   return (color * (A * color + B)) / (color * (C * color + D) + E);
}

uniform int    AA;           // antialiasing level
uniform vec2   resolution;
uniform float  time;
uniform bool   iApply;       // toggle on/off applying transformation
uniform bool   iElliptic;    // toggle on/off elliptic transformation
uniform bool   iHyperbolic;  // toggle on/off hyperbolic transformation
uniform Mobius iMobius;

// The grid size
const float modPhase = 7.0;
const float modModulus = 0.4;

// Speed of the animation
const float time_unit = 2.5;
const float hue_time_unit = 1.8;

// Angle of the cone
const vec2 coneAngle = normalize(vec2(1.5, 1.0));

vec2 fragCoord = gl_FragCoord.xy;

bool parabolic;
bool loxodromic;


float applyMobius(inout vec3 p)
{

    p = M_Apply(iMobius, vec4(p, 0)).xyz;
    float scale = length(p);
    if(scale > 1.0)
        scale = 1.0 / scale;
    return scale;
}


// A Mobius transformation of hyperblic type is
// conjugate to a pure scaling
void isometryHyperbolic(inout vec2 p)
{
    float mag = length(p);
    mag = UHStoH(mag) - time * time_unit * modModulus;
    Mod(mag, modModulus);
    p = normalize(p) * HtoUHS(mag);
}

// A Mobius transformation of elliptic type is
// conjugate to a pure rotation
void isometryElliptic(inout vec2 p)
{
    p = Rotate2d(p, time * time_unit * PI / modPhase);
}

// A Mobius transformation of parabolic type is
// conjugate to a pure translation
void isometryParabolic(inout vec2 p)
{
    p += vec2(time * modModulus / 3.0, 0.0);
}

// This is almost the same with the usual cone distance function
// except that we firstly scaled p so that it has length 1, then
// compute its distance to the cone and finally scaled back to get
// the right distance. This is for floating accuracy reason because
// when p approaches infinity the cone distance function behaves badly
// and Dupin cyclide looks bad at one horn.
float coneSdf(vec3 p)
{
    float t = 1.0;
    if(iApply)
    {
        t = applyMobius(p);
        p = normalize(p);
    }
    float q = length(p.xy);
    return dot(coneAngle, vec2(q, -p.z)) * t;
}

// Scene distance function for parabolic case (one fixed point)
float sceneSdf1(vec3 p)
{
    float horosphereEuclideanRadius = 0.9;
    if(!iApply)
    {
        // The horosphere as a plane will be at the height of
        // its north pole inverted in the unit sphere.
        float height = 1.0 / ( 2.0 * horosphereEuclideanRadius );
        return planeSdf(p, height);
    }

    float plane_dist = planeSdf(p);
    float sphere_dist = sphereSdf(p, horosphereEuclideanRadius);
    return min(plane_dist, sphere_dist);
}

// Scene distance function for elliptic and hyperbolic case (two fixed points)
float sceneSdf2(vec3 p)
{
    float plane_dist = planeSdf(p);
    float cone_dist = coneSdf(p);
    return min(plane_dist, cone_dist);
}


// Intensity constants
const float intensity_divisor = 40000.0;
const float intensity_factor_max = 7.2;
const float center_intensity = 12.0;
const float dist_factor = 3.0;
const float ppow = 1.9;

// Color constants
const float center_hue = 0.5;
const float center_saturation = 0.18;

// Shape constants
const float strong_factor = 0.25;
const float weak_factor = 0.19;
const vec2 star_hv_factor = vec2(9.0, 0.3);
const vec2 star_diag_factor = vec2(12.0, 0.6);

// Raymarching constants
const int   MAX_TRACE_STEPS = 255;
const float MIN_DIST = 0.0;
const float MAX_DIST = 1000.0;
const float EPSILON = 0.00001;


float getIntensity1(vec2 p)
{
    // Horizontal and vertical branches
    float dist = length(p);
    float disth = length(p * star_hv_factor);
    float distv = length(p * star_hv_factor.yx);

    // Diagonal branches
    vec2 q = 0.7071 * vec2(dot(p, vec2(1.0, 1.0)), dot(p, vec2(1.0, -1.0)));
    float dist1 = length(q * star_diag_factor);
    float dist2 = length(q * star_diag_factor.yx);

    // Middle point star intensity
    float pint1 = 1.0 / (dist * dist_factor + 0.015)
                + strong_factor / (disth * dist_factor + 0.01)
                + strong_factor / (distv * dist_factor + 0.01)
                + weak_factor / (dist1 * dist_factor + 0.01)
                + weak_factor / (dist2 * dist_factor + 0.01);

    if(pint1 * intensity_factor_max > 6.0)
        return center_intensity * intensity_factor_max * pow(pint1, ppow) / intensity_divisor;

    return 0.0;
}


float getIntensity2(vec2 p)
{
    float angle = atan(modModulus, PI / modPhase);
    float dist = length(p);
    float disth = length(p * star_hv_factor);
    float distv = length(p * star_hv_factor.yx);

    vec2 q1 = Rotate2d(p, angle);
    float dist1 = length(q1 * star_diag_factor);
    vec2 q2 = Rotate2d(p, -angle);
    float dist2 = length(q2 * star_diag_factor);

    float pint1 = 1.0 / (dist * dist_factor + 0.015)
                + strong_factor / (disth * dist_factor + 0.01)
                + strong_factor / (distv * dist_factor + 0.01)
                + weak_factor / (dist1 * dist_factor + 0.01)
                + weak_factor / (dist2 * dist_factor + 0.01);
    if(pint1 * intensity_factor_max > 6.0)
        return intensity_factor_max * pow(pint1, ppow) / intensity_divisor * center_intensity * 3.0;

    return 0.0;
}


vec3 getColor(vec2 p, float pint)
{
    float saturation = 0.75 / pow(pint, 2.5) + center_saturation;
    float time2 = parabolic ?
                  hue_time_unit * time - length(p.y) / 5.0 :
    	          hue_time_unit * time - UHStoH(length(p)) / 7.0;
    float hue = center_hue + time2;
    // Really a hack of magic code to make the stars work well
    return hsv2rgb(vec3(hue, saturation, pint)) + pint / 3.0;
}


float trace(vec3 eye, vec3 marchingDir, float start, float end, out vec2 p, out float pint)
{
    float depth = start;
    vec3 current;
    float dist;
    for(int i=0; i < MAX_TRACE_STEPS; i++)
    {
        current = eye + depth * marchingDir;
        dist = parabolic ?
               sceneSdf1(current) :
               sceneSdf2(current);
        if(dist < EPSILON)
            break;
        depth += dist;
        if(depth >= end)
            return -1.0;
    }
    vec3 hitPoint = current;
    if(parabolic)
    {
        float t = 1.0;
        if(iApply)
        {
            t = dot(hitPoint, hitPoint);
            hitPoint /= t;
        }
        p = hitPoint.xy;
        isometryParabolic(hitPoint.xy);
        float spacing = modModulus / 2.0;
        Mod2d(hitPoint.xy, vec2(spacing, spacing));
        pint = getIntensity1(hitPoint.xy);
    }
    else
    {
        applyMobius(hitPoint);
        p = hitPoint.xy;
        if(iHyperbolic)
            isometryHyperbolic(hitPoint.xy);
        if(iElliptic)
            isometryElliptic(hitPoint.xy);
        Mod2dPolar(hitPoint.xy, vec2(modModulus, PI / modPhase));
        pint = getIntensity2(hitPoint.xy);
    }
    return depth;
}


void main()
{
    parabolic = !(iElliptic || iHyperbolic);
    loxodromic = iElliptic && iHyperbolic;

    vec2 pixelSize = vec2(1.0);
    pixelSize.y *= resolution.y / resolution.x;
    vec3 eye = vec3(-4.0, -6.0, 4.0);
    vec3 lookat = vec3(0.0, 0.0, 0.6);
    vec3 up = vec3(0.0, 0.0, 1.0);
    mat3 viewToWorld = viewMatrix(eye, lookat, up);
    vec3 color = vec3(0.1);
    for(int ii=0; ii < AA; ++ii)
    {
        for(int jj=0; jj < AA; ++jj)
        {
            vec2 sampleCoord = fragCoord + vec2(float(ii)/AA, float(jj)/AA) * pixelSize;
            vec3 viewDir = rayDirection(45.0, resolution.xy, sampleCoord);
            vec3 worldDir = viewToWorld * viewDir;
            vec2 p;
            float pint;
            float dist = trace(eye, worldDir, MIN_DIST, MAX_DIST, p, pint);
            if(dist >= 0.0)
                color += tonemap(4.0 * getColor(p, pint));
        }
    }
    gl_FragColor = vec4(color / (AA * AA), 1.0);
}

