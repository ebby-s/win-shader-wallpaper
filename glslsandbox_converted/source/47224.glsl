#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 pos=(gl_FragCoord.xy/resolution)*2.0-1.0 ;
 pos.x*=resolution.x/resolution.y ;
 
 
 vec3 color=vec3(0.07) ;
 
 pos*=1.0/sin(time) ;
 
 color=vec3(0.009/pow(distance(pos, vec2(0.0)),4.0))*pow(pos.x,3.0)*4.0 ;
 
 
 
 
 
 gl_FragColor=vec4(color,1.0) ;
}