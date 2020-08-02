#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.yy ) + mouse / 4.0;
 float radius = 0.5 + pow(0.5*sin(2.*time), 4.);

 float color = 0.0;
 
 vec2 normRes = resolution.xy / resolution.yy;
 
 //Centering the coordinate screen
 position.y -= normRes.y*0.5;
 position.x -= normRes.x*0.5;
 
 //Deforming the co-ordinate axis to form a heart
 position.y += .2*position.y;
 position.y -= abs(position.x)*sqrt(abs((.8 - 0.*position.x)/1.2));
 position.y -= 0.1;
 
 //x^2 + y^2 = r^2 equation of a circle
 if((pow(position.x , 2.) + pow(position.y, 2.)) < pow(radius, 2.)){
  color = .5 - abs(position.x);
  color += 0.5;
 }

 gl_FragColor = vec4(  color, 0.0, 0.0, 1.0 );

}