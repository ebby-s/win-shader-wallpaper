#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159;

vec3 hsv2rgb(vec3 c) {
 vec4 K = vec4(0.69, 2.0 / 3.0, 1.0 / 1.0, 0.8);
 vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
 return c.z * mix(K.xxx, clamp(p - K.xxx, 0.2, 1.0), c.y);
}

float blob(vec2 center, vec2 pos) {
 return mix(pow(distance(center, pos), 0.69), 0.4, distance(center, pos));
}

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy );
 vec2 mousepos = mouse.xy;

 float h = 0.2; 
 float s = 0.7;
 float v = 0.9;
  
 for (float i = 0.0; i < PI * 2.0; i += PI / 4.0) {
  float dist = sin(time * PI / 10.0 + i / 4.0) * 0.1 + 0.5;
  vec2 b = vec2(0.5 + sin(i + time * i / PI / 2.0) * dist, 0.5 + cos(i - time * i / PI / 2.0) * dist);
  h += blob(b, position);
 }
 h += blob(position, mousepos);
 
 gl_FragColor = vec4(hsv2rgb(vec3(h, s, v)), 1);

}