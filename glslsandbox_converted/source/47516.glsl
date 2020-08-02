#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy ) + 2.5;
 
 
 position.x += sin(position.y * cos(time) * 0.05) * 0.05;

 float color = 0.0;
 color += 1.0 * (sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 )+ dot(-position, position));
 color += 1.0 * ( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
 color += 1.0 * (sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 ));
 color *= 1.0 * (sin( time / 10.0 ) * 0.5);

 gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}