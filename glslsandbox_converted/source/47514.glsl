#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float ring(vec2 u) {
 float outer = smoothstep(.1, .45, length(u));
 float inner = 1. - smoothstep(.3, .34, length(u));
 return 1. - (outer - inner);
}

void main( void ) {
 vec2 u = (2. * gl_FragCoord.xy - resolution) / resolution.y;
 vec3 b = vec3(.8, .5, 0.);
 vec3 f = vec3(0., .9, .9);
 float l = .01 / ring(u);
 gl_FragColor = vec4(b + f * l, 1.);
}