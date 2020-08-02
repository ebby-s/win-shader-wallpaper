#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

#define PI 3.1415926535897932384626433832795

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

vec4 ccol(float hue) {
 return vec4((1. + vec3(sin(hue), sin(hue + 2. * PI / 3.), sin(hue + 4. * PI / 3.))) / 2., 1.);
}

vec2 cmul(vec2 a, vec2 b) {
 return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

vec2 car(float a, float r) {
 return vec2(cos(a), sin(a)) * r;
}

void main(void) {
 vec2 position = 2. * gl_FragCoord.xy / resolution.yy - vec2(resolution.x / resolution.y, 1.);
 
 int i;

 // vec2 mult = vec2(2., mod(time, 10.) - 5.);
 // vec2 work = position;
 
 float angle = PI / 6.;
 
 vec2 work = car(mod(time, 10.) / 5. * PI, mod(time, 10000.) / 10000.);
 vec2 mult = position * 2.;

 for( int j = 0 ; j < 1000 ; j++ ) {
  work = cmul(mult, cmul(work, vec2(1., 0.) - work));
  i = j;
  
  if( length(work) > 2. )
   break;
 }

 gl_FragColor = ccol(float(i) / 10.);
}