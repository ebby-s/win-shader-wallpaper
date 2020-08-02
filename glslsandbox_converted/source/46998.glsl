#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

 
 
 float color = 0.0;
 color += tan( position.x * tan( time / 15.0 ) * 80.0 ) + cos( position.y * tan( time / 15.0 ) * 10.0 );
 color += tan( position.y * sin( time / 10.0 ) * 40.0 ) + sin( position.x * sin( time / 25.0 ) * 40.0 );
 color *= sin( time / 10.0 ) * 0.5;

 gl_FragColor = vec4( vec3( color*1.7, color * 0.5, sin( color + time / 1.0 ) * 2.5 ), 1.0 );

}