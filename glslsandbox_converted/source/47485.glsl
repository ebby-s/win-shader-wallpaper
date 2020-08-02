#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

vec3 getColor(float phase);

#define stripes 1.
#define k 4.
#define sx surfacePosition.x
#define sy surfacePosition.y

float PI = 4.*atan(1.);

void main(void) {
 vec3 c = getColor(time*0.7*PI);
 gl_FragColor = vec4(c, 1.0);

}

vec3 getColor(float phase) {
 float x = sx*0.03;
 float y = sy*0.03;
 float theta = atan(y, x) * 1.;
 float r = log(x*x + y*y) ;//(mouse.x*2.);
 float c = 0.;
 float tt;
 for (float t=0.; t<k; t++) {
  float tt = t * PI;
  c += cos((theta*cos(tt) - r*sin(t)) * stripes + phase);
 }
 //c = (c+k) / (k*2.);
 //c = c > 0.5 ? 1. : 0.;
 c/=k/2.;
 return vec3(abs(c), c*c, -c);
 //return vec3(c, c, c);

}