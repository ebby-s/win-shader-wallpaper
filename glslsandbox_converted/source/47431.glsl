#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float nr = 5.0;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy );

 vec3 color = vec3(0.0);
 
 for(float i = 0.0;i<nr;i+=1.)
 {
  color.r += 0.1/(abs(((sin(position.x+time+i)+1.)*0.5)-position.y)*nr);
  color.g += 0.1/(abs(((sin(position.x+time+i+1.0)+1.)*0.5)-position.y)*nr);
  color.b += 0.1/(abs(((sin(position.x+time+i+2.0)+1.)*0.5)-position.y)*nr);
 }
 

 gl_FragColor = vec4( color, 1.0 );

}