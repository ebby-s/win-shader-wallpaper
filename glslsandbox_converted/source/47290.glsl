#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float map(vec3 p) {
 return length(mod(p, 2.0) - 1.0) - 0.4;
}

void main( void ) {

 vec2 uv = 2.0  *  ( gl_FragCoord.xy / resolution.xy )  - 1.0;
 vec3 dir = normalize(vec3(uv, 1.0));
 vec3 pos = vec3(0, 0, time);
 float t = 0.0;
 for(int i = 0 ; i < 50; i++) t += map(t * dir + pos);
 gl_FragColor = vec4(t * 0.01) + map(t * dir + pos - 0.2);
}