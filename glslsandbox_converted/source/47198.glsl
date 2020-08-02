#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 resolution;

float dust(vec2 uv) {
  float t = .4 + smoothstep(0.02, .8, -uv.y * 5.); // top line

  uv.y += sin(uv.x + time * .5) / 3.;
  uv.x += sin(uv.y + time * .5) / 3.;
  uv *= 10.; // particle count
  vec2 s = floor(uv), f = fract(uv), p;
  float k = 3., d;
  p = .2 + .35 * sin(11. * fract(sin(s * mat2(vec2(8, 2), vec2(6, 5))) * 2.)) - f;
  d = length(p);
  k = min(d, k);
  k = smoothstep(0., k, sin(f.x + f.y) * 0.015); // britness
  return k * t / 2.;
}

void main(void){
  vec2 uv = (gl_FragCoord.xy * 2.-resolution.xy) / min(resolution.x, resolution.y);
  float c = dust(uv);
  gl_FragColor = vec4(c, c/1.5, 0., .0);
}
