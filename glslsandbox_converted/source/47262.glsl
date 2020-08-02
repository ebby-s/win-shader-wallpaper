#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 pos = ( gl_FragCoord.xy / resolution.xy );

 pos.x += sin(pos.y+time);
 
 
 vec2 position;
 float multi = 0.01;
 
 position.x = pos.x*cos(time*multi)+pos.y*sin(time*multi);
 position.y = pos.y*sin(time*multi)+pos.y*cos(time*multi);

 
 
 
 float value = sin(position.x*10. + time);
 
 

 
 gl_FragColor = vec4( vec3(cos(abs(position.y-value)), abs(cos(position.y)-value),abs(position.y-value)), 1.0 );

}