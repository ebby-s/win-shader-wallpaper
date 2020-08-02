#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define pi 3.1415926

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy ) - mouse;
 
 float colorR = 0.7*sin(-time);
 float colorG = 0.7*sin(time);
 float colorB = 0.7*sin(time+position.x);
 
  
 vec2 closeness =  10.*vec2(atan(position.y, position.x), length(position))+time*20.;
 colorR += cos(closeness.x) + sin(closeness.x);
 colorG += cos(closeness.x) + sin(closeness.x);

 gl_FragColor = vec4( vec3( colorR, colorG, colorB), 1.0 );

}