#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy );

 float d = 1.0/5.0;
 float r = position.y > d*1.0 &&  position.y < d*4.0 ? 1.0 : 0.0;
 float g = position.y > d*2.0 && position.y < d*3.0 ? 1.0 : 0.0;

 gl_FragColor = vec4( vec3(r,g,1), 1.0 );

}