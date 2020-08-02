#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 uv = ( gl_FragCoord.xy / resolution.xy );
         
 float a=mod(floor(8.*uv.y),2.0)+mod(floor(8.*uv.x),2.0);
 
 gl_FragColor = vec4( a,a,a, 1.0 );

}