#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

#define STEPS 1000
#define CAMERA_DISTANCE 10.0

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {
 vec3 s = vec3(
  gl_FragCoord.x - resolution.x / 2.0,
  gl_FragCoord.y - resolution.y / 2.0,
  CAMERA_DISTANCE
 );
 
 vec3 cs = vec3(
  resolution.x / 2.0,
  resolution.y / 2.0,
  10
 );
 
 vec3 p = vec3(
  resolution.x / 2.0,
  resolution.y / 2.0,
  -CAMERA_DISTANCE
 );
 
 bool hit = false;
 
 for (int i = 0; i < STEPS; ++i) {
  //if (length(p - cs) < 1000.0) {
   gl_FragColor = vec4(1.0, 0.0, 0.0, 0.0);
   hit = true;
   break;
  //}
  
  p += s;
 }
 
 if (!hit) {
  gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
 }
}