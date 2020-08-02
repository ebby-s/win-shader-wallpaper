#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
 vec4 color = vec4 ( 0.0, 0.0, 0.0, 1.0 );
 float step = sin ( gl_FragCoord.x/resolution.x*3.0)/1.5; 
 color = vec4( step, step, step, 1.0 );
 float quat = sin ( gl_FragCoord.x * gl_FragCoord.y / time*2500.0 * fract( gl_FragCoord.x / time ));
 gl_FragColor = color * quat;
}