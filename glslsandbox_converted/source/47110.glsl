#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 //vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
 
 vec2 xy = gl_FragCoord.xy * 0.8;
 
 
 int x =  int(xy.x)/10 ;
 int y =  int(xy.y)/10;
 
 float v = 0.0;
 //if( x==2 && y ==2 || x==3 && y ==2 || x==3 && y ==3 || x==3 && y ==4)
 // v = 1.0;
 //if(xy && (true,true))
 // v = 1.0;
 //if(xy - vec2(2.0,2.0))
  v =1.0;
 v = 1.- length(vec2(x,y) - vec2(1.0,1.0))* 
  length(vec2(x,y) - vec2(3.0,1.0))*
  length(vec2(x,y) - vec2(1.0,2.0))*
  length(vec2(x,y) - vec2(3.0,2.0))*
  length(vec2(x,y) - vec2(1.0,3.0))*
  length(vec2(x,y) - vec2(2.0,3.0))*
  length(vec2(x,y) - vec2(3.0,3.0))*
  length(vec2(x,y) - vec2(1.0,4.0))*
  length(vec2(x,y) - vec2(3.0,4.0))*
  length(vec2(x,y) - vec2(1.0,5.0))*
  length(vec2(x,y) - vec2(3.0,5.0))*   //H
  
  length(vec2(x,y) - vec2(5.0,1.0))*
  length(vec2(x,y) - vec2(6.0,1.0))*
  length(vec2(x,y) - vec2(7.0,1.0))*
  length(vec2(x,y) - vec2(5.0,2.0))*
  length(vec2(x,y) - vec2(7.0,2.0))*
  length(vec2(x,y) - vec2(5.0,3.0))*
  length(vec2(x,y) - vec2(7.0,3.0))*
  length(vec2(x,y) - vec2(5.0,4.0))*
  length(vec2(x,y) - vec2(7.0,4.0))*
  length(vec2(x,y) - vec2(5.0,5.0))*
  length(vec2(x,y) - vec2(6.0,5.0))*
  length(vec2(x,y) - vec2(7.0,5.0))*   //O
  
  length(vec2(x,y) - vec2(9.0,1.0))*
  length(vec2(x,y) - vec2(11.0,1.0))*
  length(vec2(x,y) - vec2(9.0,2.0))*
  length(vec2(x,y) - vec2(11.0,2.0))*
  length(vec2(x,y) - vec2(9.0,3.0))*
  length(vec2(x,y) - vec2(10.0,3.0))*
  length(vec2(x,y) - vec2(9.0,4.0))*
  length(vec2(x,y) - vec2(11.0,4.0))*
  length(vec2(x,y) - vec2(9.0,5.0))*
  length(vec2(x,y) - vec2(10.0,5.0))*
  length(vec2(x,y) - vec2(11.0,5.0))  //R
  ;
 gl_FragColor = vec4(v,v,v,1.0);
 //gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
}