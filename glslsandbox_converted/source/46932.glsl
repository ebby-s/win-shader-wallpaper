#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi = 3.1415;

float radian(float degree) {
 return (degree * 100.0) / 180.0 * pi;
}

vec3 rgb(vec3 color) {
 vec3 result = color / 2.0;
 return result;
}

void main() {
 vec2 uv = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);
 for(float i = 0.0; i < 50.0; i++) {
  vec3 destColor = vec3(0.0);
  float radius = 0.07;
  float x = cos(radian(time)) * 0.5;
  float y = sin(radian(time)) * 0.5;
  float uvX = uv.x + (-1.0 * x);
  float uvY = uv.y + (-1.0 * y);
  vec2 position = vec2(uvX, uvY);
  destColor += radius / length(position);
  gl_FragColor = vec4(destColor, 1.0);
 }
}