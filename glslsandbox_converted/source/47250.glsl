#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
varying vec2 surfacePosition;

void main( void ) {
 
 vec2 pos = vec2(10.0);
 
 float dist = distance(surfacePosition , vec2(0));
 
 gl_FragColor = vec4( vec3( 1.0, 0 ,0 ), 1.0 - dist);
 gl_FragColor *= gl_FragColor.w;
}