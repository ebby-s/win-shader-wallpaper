#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 //vec2 center = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
 vec2 center = vec2(resolution.x, resolution.y);
 float distanceFromCenter = length(center);
 float radius = 0.2;
 
 // uncomment me to modulate the radius based on the current time
 radius *= sin(time) + 1.0;
 
 float hardEdgeThreshold = step(radius, distanceFromCenter); 
 gl_FragColor = vec4(vec3(hardEdgeThreshold), 1.0 );

}