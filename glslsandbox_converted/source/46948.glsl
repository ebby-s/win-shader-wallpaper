#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives: enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float noise(vec2 p) {
  return fract(sin(p.x + p.y * 10000.) * 10000.);
}

vec2 sw(vec2 p) {
  return vec2(floor(p.x), floor(p.y));
}
vec2 se(vec2 p) {
  return vec2(ceil(p.x), floor(p.y));
}
vec2 nw(vec2 p) {
  return vec2(floor(p.x), ceil(p.y));
}
vec2 ne(vec2 p) {
  return vec2(ceil(p.x), ceil(p.y));
}

float smoothNoise(vec2 p) {
  vec2 interp = smoothstep(0., 1., fract(p));
  float s = mix(noise(sw(p)), noise(se(p)), interp.x);
  float n = mix(noise(nw(p)), noise(ne(p)), interp.x);
  return mix(s, n, interp.y);
}

float fractalNoise(vec2 p) {
  float x = 0.;
  x += smoothNoise(p);
  x += smoothNoise(p * 2.) / 2.;
  x += smoothNoise(p * 4.) / 4.;
  x += smoothNoise(p * 8.) / 8.;
  x += smoothNoise(p * 16.) / 16.;
  x /= 1. + 1. / 2. + 1. / 4. + 1. / 8. + 1. / 16.;
  return x;
}

float movingNoise(vec2 p) {
  float x = fractalNoise(p + time);
  float y = fractalNoise(p - time);
  return fractalNoise(p + vec2(x, y));
}

// call this for water noise function
float nestedNoise(vec2 p) {
  float x = movingNoise(p);
  float y = movingNoise(p + 100.);
  return movingNoise(p + vec2(x, y));
}
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fragCoord.xy / resolution.xy;
  float n = nestedNoise(uv * 6.);

  fragColor = vec4(mix(vec3(.4, .6, 1.), vec3(.1, .2, 1.), n), 1.);
}

void main(void) {

  vec2 position = (gl_FragCoord.xy / resolution.xy); //+ mouse / 4.0
  position.y += mouse.x*(sin(2.0*time-gl_FragCoord.x/resolution.x)/5.0);
  if (mouse.x>0.5)
    position.x += time/2.0;
  else
    position.x += time/10.0;

  vec2 uv = gl_FragCoord.xy / resolution.xy;
  float n = nestedNoise(uv * 6.);
  if (position.y < -abs(sin(position.x * 30.0 - time)) / 15.0 + 0.4)
    gl_FragColor = vec4(mix(vec3(.4, .6, 1.)*1.3, vec3(.1, .2, 1.)*1.3, n), 1.);
  else if (position.y < -abs(sin(position.x * 30.0)) / 15.0 + 0.5)
    gl_FragColor = vec4(mix(vec3(.4, .6, 1.), vec3(.1, .2, 1.), n), 1.);
  else if (position.y < -abs(sin(position.x * 30.0 + time)) / 15.0 + 0.6)
    gl_FragColor = vec4(mix(vec3(.4, .6, 1.)*0.8, vec3(.1, .2, 1.)*0.8, n), 1.);
  else
    gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);

}