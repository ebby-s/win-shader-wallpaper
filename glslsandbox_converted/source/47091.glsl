#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

#define pi 3.14159265359

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
 
 vec2 position = gl_FragCoord.xy / resolution;
 
 vec2 center = vec2(0.5, 0.5);
 float startAngle = mod(0.0, pi/2.0);
 
 vec2 direction = position - center;
 
 float angle = atan(-direction.y, -direction.x);
     float linearLocation = fract((angle - time - pi) / (pi * 2.0));
 float location = smoothstep(0.0, 1.0, linearLocation);

 if (location <= 0.5) {
  gl_FragColor = vec4( mix(vec3(0.0, 0.0, 0.0), vec3(1.0, 0.0, 0.0), smoothstep(0.0, 0.5, location)), 1.0 );
 }
 else {
  gl_FragColor = vec4( mix(vec3(1.0, 0.0, 0.0), vec3(0.0, 0.0, 0.0), smoothstep(0.5, 1.0, location)), 1.0 ); 
 }
  

}