#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pattern(vec2 uv) {
 return sin(3. * time  + 10. * length(uv));
}

mat2 rotate(float a) {
 return mat2(cos(a), -sin(a),
     sin(a), cos(a));
}

void main( void ) {
 
 vec2 uv = rotate(time / 5.) *
  ((2. * gl_FragCoord.xy - resolution.xy) 
  / resolution.y);
 
 float l = length(uv);
 
 float inv = 1. / l;
 vec2 uvp = mod(
  uv * inv - vec2(inv * 3. + time / 2., 0.) + 1.,
  vec2(2.)) - 1.;

 vec3 image = vec3(
  pattern(uvp * 2.) * l / 2. + abs(cos(time*7.)) - 0.7,
  pattern(uvp * 7.) * l / 2. + abs(cos(time*4.)) - 0.5,
  pattern(uvp * 10. + cos(time)) * l / 2.) + abs(cos(time*3.))  - 0.7;
 
 gl_FragColor = vec4(image, 2. );
 
}