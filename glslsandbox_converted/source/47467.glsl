#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy );

 float color = 0.0;
 color = sin( position.x / 10.0 ) * 0.5;

 gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}