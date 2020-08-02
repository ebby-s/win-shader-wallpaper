#ifdef GL_ES
precision highp float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
 vec2 p = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
 p -= mouse * 2.0 - 1.0;
 p.x *= resolution.x/resolution.y;
 float v = 0.1 / sqrt(length(p * vec2(0.3, 1.0)));
 gl_FragColor = vec4(v, v, v, 1.0);

}