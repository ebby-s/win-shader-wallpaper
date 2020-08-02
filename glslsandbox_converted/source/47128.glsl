#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
 
 vec2 center = resolution.xy / 2.0;
 vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
 vec2 d = center.xy - position.xy;

 float dist = sqrt((d.x * d.x) + (d.y * d.y));

 gl_FragColor = vec4( vec3( dist, dist, dist ), 1.0 );

}