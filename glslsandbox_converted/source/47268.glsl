#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat3 translate(vec2 v) {
 return mat3(
  1., 0., 0.,
  0., 1., 0,
  -v.x, -v.y, 1.
 );
}

mat3 rotate(float a) {
 return mat3(
  cos(a), -sin(a), .0,
  -sin(a), cos(a), 0.,
  0., 0., 1.
 ); 
}

float sinp(float a) { return 0.5 + 0.5 * sin(a); }

void main( void ) {
 vec3 st = vec3(gl_FragCoord.xy / resolution, 1.0);
 vec2 aspect = vec2(resolution.x / resolution.y, 1.0);
3.14150;
 st.xy -= 1.0;
 st.xy *= aspect;
 st = translate(mouse * 2.0 - 1.) * st;
 
 vec3 col;
 
 float t = time;
 
 for (int i = 0; i < 3; i++) {
  t += (sin(time + (2. + 10. * mouse.x) * length(st) + atan(st.y, st.x) * 5.)
       * sin(time + (2. + 10. * mouse.y) * length(st) - atan(st.y, st.x) * 5.)
       );
  float c = sin(5. * t - length(st.xy) * 10. * sinp(t));
  col[i] = c;
 }
 
 
 
 gl_FragColor = vec4(vec3(1.0, 0., col.g) * col, 1.0);
}