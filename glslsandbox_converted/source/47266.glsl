#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

#define MAX_ITR 256

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

varying vec2 surfacePosition;

float map(vec2 uv) {
 
 vec2 z = vec2(0.);
 
 for (int k = 0; k < MAX_ITR; ++k) {
  z = vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y) + uv;
  uv = -uv;
  if (dot(z,z) > 4.) {
   return float(k) / float(MAX_ITR);
  }
 }
 
 return 1.0;
}

void main() {
 gl_FragColor = vec4(map(surfacePosition));

}