#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{
 vec2 position = ( gl_FragCoord.xy / resolution.xy );
 
 
 
 position.x*=20.;

 position.x += (time+500.)*0.1*(mouse.x-0.5);
 position.y += (time+500.)*0.1*(mouse.y-0.5);
 
 vec3 color = vec3(0.0);
 

 float left = sin(pow(position.x,2.)+pow(position.y,2.));
 float right = cos(position.x*position.y);
 
 
 float diff = abs(left-right);
 
 color = vec3(diff);
 
 
 gl_FragColor = vec4( color, 1.0 );

}