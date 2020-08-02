// written by: saidwho12

#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define inf 1.e32
const float PI = 3.14159,
 eps = .00001,
 t_min = .01,
 t_max = 1000.;
const int iter_max = 256;


float sdBox( vec3 p, vec3 b ) {
  vec3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

mat3 rotateX( in float theta ) {
 float s = sin(theta), c = cos(theta);
 return mat3(1, 0, 0,
     0, c, s,
     0, -s, c);
}

mat3 rotateY( in float theta ) {
 float s = sin(theta), c = cos(theta);
 return mat3(c, 0, -s,
     0, 1, 0,
     s, 0, c);
}

float opS( in float d1, in float d2 ) {
 return max(d1, -d2);
}

float opI( in float d1, in float d2 ) {
 return max(d1, d2);
}

// Repeat around the origin by a fixed angle.
// For easier use, num of repetitions is use to specify the angle.
float pModPolar(inout vec2 p, float repetitions) {
 float angle = 2.*PI/repetitions;
 float a = atan(p.y, p.x) + angle/2.;
 float r = length(p);
 float c = floor(a/angle);
 a = mod(a,angle) - angle/2.;
 p = vec2(cos(a), sin(a))*r;
 // For an odd number of repetitions, fix cell index of the cell in -x direction
 // (cell index would be e.g. -5 and 5 in the two halves of the cell):
 if (abs(c) >= (repetitions/2.)) c = abs(c);
 return c;
}

float f( in vec3 p ) {
 vec3 b = vec3(1.+.0001, vec2(.3333333));
 vec3 theta = .25*vec3(PI*time);
 vec3 p0 = rotateX(theta.x)*p;
 //pModPolar(p0.xy, 12.);
 return opS(sdBox(p0, vec3(1)), min(min(sdBox(p0, b), sdBox(p0, b.yxz)), sdBox(p0, b.zyx)));
}

vec3 n( in vec3 p ) {
 return normalize(vec3(
  f(vec3(p.x+eps, p.yz)) - f(vec3(p.x-eps, p.yz)),
  f(vec3(p.x, p.y+eps, p.z)) - f(vec3(p.x, p.y-eps, p.z)),
  f(vec3(p.xy, p.z+eps)) - f(vec3(p.xy, p.z-eps))
 ));
}
 
float trace( in vec3 ro, in vec3 rd ) {
 float t = 0.;
 for(int i = 0; i<iter_max; ++i) {
  float r = f(ro+rd*t);
  t+=r;
  if(r<eps) return t>t_max ? inf : t;
 }
 return inf;
}

void main( void ) {
 vec2 p = (2.*gl_FragCoord.xy - resolution.xy) / resolution.y;
 vec3  ro = vec3(0,0,3),
  fw = vec3(0,0,-1),
  up = vec3(0,1,0),
  ri = cross(fw, up),
  rd = normalize(fw+p.x*ri+p.y*up),
  c = vec3(0);
 float t = trace(ro, rd);
 if(t!=inf) {
  vec3 P = ro+rd*t, N = n(P);
  //c += fract(P-.5);
  //c += fract(t);
  c += N;
 }
 
 gl_FragColor = vec4(c, 1);
}