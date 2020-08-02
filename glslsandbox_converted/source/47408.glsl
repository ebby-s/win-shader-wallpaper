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
 
 float colorR = 0.;
 float colorG = 0.7;
 float colorB = 0.7;
 
 float angle = ((time*25.)/180.)*pi;
 
 float dist = sqrt(pow(position.x,2.) + pow(position.y,2.));
 vec2 closeness = 50.*normalize(normalize(position.xy)-vec2(cos(angle), sin(angle)));
 colorR += cos(closeness.x) + sin(closeness.x);
 colorG += cos(closeness.x) + sin(closeness.x);

 gl_FragColor = vec4( vec3( colorR, colorG, colorB), 1.0 );

}