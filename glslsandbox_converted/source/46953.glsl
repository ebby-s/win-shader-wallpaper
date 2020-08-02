#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives: enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

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

float nestedNoise(vec2 p) {
  float x = movingNoise(p);
  float y = movingNoise(p + 100.);
  return movingNoise(p + vec2(x, y));
}

void main(void) {
  vec2 position = gl_FragCoord.xy / resolution.xy + surfacePosition;
 
  position.x += time / 3.0;
  //position.y += sin(time - position.x * 2.0) / (mouse.x * 50.0 + 5.0);

  vec3 c1 = vec3(.4, .6, 1.);
  vec3 c2 = vec3(.1, .2, 1.);
 
    gl_FragColor = vec4(0.5, 0.75, 1., 1.0);
 for(int i=0;i<20;i++){
  float q=(float(i)/4.0)+0.3;
  /**/ if (position.y-1.0 < (-abs(nestedNoise(vec2(position.x,1.0*q))) -1.0)/(1.0+q)){
    gl_FragColor = vec4(mix(c1 * 3.0/(q+2.0), c2 * 3.0/(q+1.0), nestedNoise(position * q)), 1.);
  break;
  }
  
 }
}