#ifdef GL_ES
precision mediump float;
#endif
const vec3 white = vec3(.5,.5,.7);
const vec3 black = vec3(.4,.4,.6);
const vec3 line_color = vec3(.3,.3,.5);
const float sz = 20.;
uniform float time;

void main() { // Houndstooth
  vec2 p = gl_FragCoord.xy;
  float osc = clamp(sin(time*2.)*5., -1., 1.) / 2. + .5;
  bool is_border = mod(p.x, sz) < 1. || mod(p.y, sz) < 1.;

  vec3 weave1 = mod(p.x, 2.*sz) < sz ? black : white;
  vec3 weave2 = mod(p.y, 2.*sz) < sz ? black : white;
  vec3 color  = mod(p.x+p.y, sz) < sz/2. ? weave1 : weave2;
  gl_FragColor = vec4(mix(line_color, color, is_border ? osc : 1.), 1.);
}