//Based on patriciogv
// http://patriciogonzalezvivo.com

#ifdef GL_FRAGMENT_PRECISION_HIGH
precision mediump float;
#else
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define PI 3.14159265359


void main(void) {
  vec2 st = gl_FragCoord.xy / resolution.xy-0.5;
  float koeff = resolution.y/resolution.x;
  st.y *= koeff;
  float u_time = 9.;

  // cartesian to polar coordinates
  float radius = length(st);
  float a = atan(st.x, st.y);
 radius += a*a/42.0;
 //gl_FragColor = vec4(a*a/10.);return;

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
  color = min(color, smoothstep(0.55, 0.33, radius));
  gl_FragColor = (length(color*vec4(3,0,0,0))*0.5+0.5*color)*(color.g-color.b*0.5);
 #define S2(D) (texture2D(backbuffer, (D+gl_FragCoord.xy)/resolution))
 gl_FragColor = max( (S2(vec2(0,-3))+S2(vec2(-2,0))+S2(vec2(0,1))*1.5+S2(vec2(0,5))/2.+S2(vec2(2,0)))*.2 , gl_FragColor)-1./256.;
}
