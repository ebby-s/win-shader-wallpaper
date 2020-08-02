#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

const float eps = 10e-6;
const int max_steps = 128;

mat4 rot = mat4(cos(0.8), sin(0.8), 0, 0,
  -sin(0.8), cos(0.9), 0, 0,
  0,  0,  1,  0,
  0,  0,  0,  1);

void main( void ) {
 vec3 camPos = vec3(0.0);
 vec2 pixelPos = (-resolution.xy + 2.0 * gl_FragCoord.xy) / resolution.y;
 
 vec3 col = vec3(0.7, 0.9, 1.0) + pixelPos.y * 0.618;
 
 gl_FragColor = vec4(col, 1.0);
}