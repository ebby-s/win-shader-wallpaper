#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

 vec3 color = vec3(0.0);
 
 color.r = (cos(time*100.)+1.)/2.;
 color.g = (sin(time*100.)+1.)/2.;
 color.b = (sin(time*100.)+1.)/2.;

 gl_FragColor = vec4( color, 1.0 );

}