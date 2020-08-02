#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
 position*= 5.;
 position-= vec2(2.5,2.5);

 
 float value = pow((position.x*position.x + position.y*position.y - 1.),3.) - position.x*position.x*position.y*position.y*position.y;
 vec3 color;
 
 if(value<0.)
  color = vec3(sin(time*0.1)*0.5+0.5,sin(time*0.2)*0.5+0.5,sin(time*0.3)*0.5+0.5);

 gl_FragColor = vec4( color, 1.0 );

}