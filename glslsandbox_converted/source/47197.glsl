/*************************
 * domains of attraction *
 *   by pdkl95           *
 *************************/

#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define TAU 6.283185307179586
#define SQ3 1.73205080756887729352744

#define cx_i vec2(0.0, 1.0)
#define cx_neg1 vec2(-1.0, 0.0)

#define cx_mul(a, b) vec2((a).x*(b).x - (a).y*(b).y, (a).x*(b).y + (a).y*(b).x)
#define cx_div(a, b) vec2(((a.x*b.x+a.y*b.y)/(b.x*b.x+b.y*b.y)),((a.y*b.x-a.x*b.y)/(b.x*b.x+b.y*b.y)))
#define cx_conj(a) vec2(a.x,-a.y)

vec2 cx_pow(vec2 z, float n) {
 float r2 = dot(z,z);
 return pow(r2,n/2.0)*vec2(cos(n*atan(z.y,z.x)),sin(n*atan(z.y,z.x)));
}

/***
 *** the attractor polynomial
 ***/
vec2 poly(vec2 z) {
 return cx_pow(z, 5.0) + cx_neg1 + cx_mul(z, cx_neg1);
}

const vec2 five = vec2(5.0, 0.0);

/***
 *** the derivitave of the attractor polynomial
 *** !!! must match poly() !!!
 *** !!!   d(poly())/dz    !!!
 ***/
vec2 dpoly(vec2 z) {
 vec2 dz = cx_pow(z, 4.0);
 return cx_mul(five, dz) + cx_neg1;
}
void main( void ) {
 vec2 position = ((gl_FragCoord.xy / resolution.xy ) * 2.0) - 1.0;
 position.y *= resolution.y / resolution.x;
 position *= 1.8;

 vec3 color = vec3(0.0);

 vec2 z = position;
 vec2 w = poly(z);
 
 
 vec2  dp = vec2(0.0);
 vec2 wdp = vec2(0.0);

 float s = 1.0;
 float f = 1.0;
 
 for (int i=0; i < 20; i++) {
  w = poly(z);
  if (                     f <= 0.01) { break; }
  if (cx_mul(w, cx_conj(w)).x > 0.01) { break; }
       
  f *= 0.95;
  s = -s;
 
  dp = dpoly(z);
  z -= cx_div(w, dp);
 }
 
 for (int n=0; n < 10; n++) {
  z = z - cx_div(poly(z), dpoly(z));
 }
 
 z = f * cx_div(cx_mul(z, z), cx_mul(z, cx_conj(z)));
 
 color.r = ( 0.24 * z.x) - ((SQ3 * 0.24) * z.y);
 color.g = ( 0.24 * z.x) + ((SQ3 * 0.24) * z.y);
 color.b = (-0.48 * z.x);

 color = 0.5 * f + color;

 gl_FragColor = vec4(color, 1.0);
}