#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

void main( void ) {

 
 float dist = distance(surfacePosition , vec2(0.0) );
 
 gl_FragColor = vec4( vec3( 1.0 - dist ), 1.0 );
}