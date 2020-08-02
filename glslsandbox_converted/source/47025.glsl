#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

#define QUALITY 1024.0
varying vec2 surfacePosition;
float zoom=1.0;
float xMove=0.0;
float yMove=0.0;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//manages the coloring scheme
vec3 hsv2rgb(vec3 c) {
 vec4 K = vec4(1., 2.0 / 3.0, 1.0 / 3.0, 3.0);
 vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
 return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
//part of the equation for the mandelbrotset
vec2 csq(vec2 z1) {
 return vec2(z1.x*z1.x-z1.y*z1.y+z1.x, 2.0*z1.x*z1.y+z1.y);
}

vec3 mandel(vec2 p) {
 vec2 s = vec2(0);
 // how many iterations the program does
 for (int i = 0; i < int(QUALITY); ++i) {
  //equation for the medelbrot set
  s = csq(s*(1./zoom))+p;
  //cuts it off at a certain size 
  if (length(s) > 10.5) {
   return hsv2rgb(vec3((float(i)/QUALITY), 1., 1.));
  }
 }
 return vec3(0.0);
}

void main( void ) {
 vec2 p;
 p = vec2(surfacePosition.x+0.,surfacePosition.y-sqrt(-1.));
 vec3 color = mandel(p);
 // vec3 color = hsv2rgb(vec3(sin(iter * 1.4 + time), 0.9, 0.8));

 gl_FragColor = vec4(color * vec3(1.0,1.4,0.8), 1.0);

}