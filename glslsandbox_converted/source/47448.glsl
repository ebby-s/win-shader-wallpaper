//Based on patriciogv
// http://patriciogonzalezvivo.com

#ifdef GL_FRAGMENT_PRECISION_HIGH
precision mediump float;
#else
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

#define PI 3.14159265359


void main(void) {
  vec2 st = gl_FragCoord.xy / resolution.xy-0.5;
  float koeff = resolution.y/resolution.x;
  st.y *= koeff;
  float u_time = time*0.8;

  // cartesian to polar coordinates
  float radius = length(st);
  float a = atan(st.y, st.x);

  // Repeat side acoriding to angle
  float sides = 8.;
  float ma = mod(a, PI*2.0/sides);
  ma = abs(ma - PI/sides);

  // polar to cartesian coordinates
  st = radius * vec2(cos(ma), sin(ma));

  st += cos(log2(0.1*u_time)+radius*PI-ma*koeff);
  st = fract(st+u_time);
  st.x = smoothstep(0.0,1.0, st.x);
  st.y = smoothstep(1.0,0.0, st.y);
  vec4 color = vec4(st.x, st.y, sin(u_time/(radius+ma)), 1.0);
  color = min(color, smoothstep(0.55, 0.5, radius));
  gl_FragColor = color;

}