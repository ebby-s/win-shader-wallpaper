#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

/*

 Author: Numinous Cranium
 Twitter: @iridule
 Instagram: @the_iridule

*/

void main( void ) {
 // tweet under 280 chars
 vec2 s=gl_FragCoord.xy/resolution-.5;gl_FragColor=vec4(vec3(sin(time+5.*sin(length(s)*25.+atan(s.x,s.y)*5.)*80.*length(s*sin(time)))),1.);
}