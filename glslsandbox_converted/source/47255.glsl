#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 p = ( gl_FragCoord.xy / resolution.xy );

 vec3 c = vec3(0);
 
 c.r=sin(p.x*20.0+mouse.x*20.0);
 
 gl_FragColor = vec4( c, 1.0 );

}