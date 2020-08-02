#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy );

 if (position.y < -abs(sin(position.x * 20.)) / 10. + .5&&0.0 < sin(30.0*(position.x - position.y))|| position.y -0.5 < sin(30.0*(-position.y + position.x))/20.0)
 gl_FragColor = vec4( 1.0,1.0,1.0, 1.0 );

}