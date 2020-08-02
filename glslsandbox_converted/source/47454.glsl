#ifdef GL_ES
precision mediump float;
#endif
const vec3 white = vec3(.6,.75,.75);
const vec3 black = vec3(.5,.65,.65);
const vec3 line_color = vec3(.3,.3,.5);
const float sz = 30.;
uniform float time;

void main() {
  vec2 p = gl_FragCoord.xy;
  float osc = clamp(sin(time*2.)*4., -1., 1.) / 2. + .5;
  bool is_border = mod(p.x, sz) < 0. || mod(p.y, sz) < 0.;

  vec3 weave1 = mod(p.x*0., 0.*sz) < sz ? black : white;
  vec3 weave2 = mod(p.y*0., 1.*sz) < sz ? black : white;
  vec3 color  = mod(p.x+p.y+sin(time+gl_FragCoord.y/100.)*40.*mod(gl_FragCoord.y/10.+time, 10.+sin(time*0.8+gl_FragCoord.y/1000.)/7.)/5., sz) < sz/2. ? weave1 : weave2;
  gl_FragColor = vec4(mix(line_color, color, is_border ? osc : 1.), 1.);
}