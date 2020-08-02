/* - ~ iridule ~ */

#ifdef GL_ES
precision mediump float;
#endif
#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 resolution;

vec2 iResolution;
float iTime;

#define repeat(v) mod(p + 1., 2.) -1.
void mainImage(out vec4 O, in vec2 I) {
     vec2 R = iResolution.xy;
 vec2 uv = (2. * I - R) / R.y; 
 vec3 o = vec3(-1., 0., iTime), d  = vec3(uv, 1.), p;
 float t = 0.;
 for (int i = 0; i < 32; i++) {
  p = o + d * t;
  p = repeat(p);
  t += (0.5 * length(p) - .3);
 }
 float l = .8 * dot(normalize(o - p), d);
 O = vec4(l  * vec3(1. / t), 1.);
}
 
void main(void) {
 iResolution = resolution;
 iTime = time;
 mainImage(gl_FragColor, gl_FragCoord.xy);
}
