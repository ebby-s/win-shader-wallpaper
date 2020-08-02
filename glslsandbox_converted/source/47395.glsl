#ifdef GL_ES
precision mediump float;
#endif
#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 resolution;


vec2 iResolution;
float iTime;

#define repeat(v) mod(p + 1., 2.) -1.
#define un(a, b) min(a, b)

mat3 rotateX(float a) {
 return mat3(
     1.0, 0.0, 0.0,
        0.0, cos(a), sin(a),
        0.0, -sin(a), cos(a)
    );
}

mat3 rotateY(float a) {
 return mat3(
     cos(a), 0.0, sin(a),
        0.0, 1.0, 0.0,
        -sin(a), 0.0, cos(a)
    );
}

float sphere_sdf(vec3 p, float r) {
 return length(p) - r;
}

float cube_sdf(vec3 p, float s) {
 return length(max(abs(p) - s, .0));
}

float ring_sdf(vec3 p) {
 float a = sphere_sdf(p + vec3(.2, .0, .0), .1);
    float b = sphere_sdf(p + vec3(-.2, .0, .0), .1);
    float A = un(a, b);
    float c = sphere_sdf(p + vec3(.0, .0, .1), .1);
    float d = sphere_sdf(p + vec3(.0, .0, -.1), .1);
    float B = un(c, d);
    return un(A, B);
}

float shape_sdf(vec3 p) {
    vec3 v = rotateY(iTime) * p;
    v.y = mod(v.y + 0.2, 0.4) - 0.2;
    return un(ring_sdf(v), 
              sphere_sdf(p * vec3(1., .01, 1.), .11));
    
}


void mainImage(out vec4 O, in vec2 I) {
     vec2 R = iResolution.xy;
 vec2 uv = (2. * I - R) / R.y; 
 vec3 o = vec3(-1., 0., iTime), d  = vec3(uv, 1.), p;
 float t = 0.;
 for (int i = 0; i < 32; i++) {
  p = o + d * t;
        p = repeat(p);
  t += .5 * shape_sdf(p);
 }
 float l = .8 * dot(normalize(o - p), d);
 O = vec4(.5 * vec3(0., uv.y, uv.y) + vec3(.0, .3, 1.) * l  * vec3(t * .3), 1.);
} 

void main(void) {
 iResolution = resolution;
 iTime = time;
 mainImage(gl_FragColor, gl_FragCoord.xy);
}
