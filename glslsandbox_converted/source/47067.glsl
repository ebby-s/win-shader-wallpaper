#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

// https://math.stackexchange.com/questions/2654984/identifying-this-chaotic-recurrence-relation

void main( void ) {
 
 gl_FragColor = vec4( 1.0 );
 
 float rho = 5./max(resolution.x, resolution.y);
 
 vec2 k = vec2(fract(time/30.)*3.14159*2.);
 vec2 xy = (mouse-.5)*2.;
 vec2 sp = 2.5*surfacePosition;
 
 if(max(abs(sp.x), abs(sp.y)) > 1.){
  gl_FragColor = vec4(0.5); 
 }
 
 for(float i = 0.; i <= 99.; i += 1.){
  if(max(abs(sp.x-xy.x), abs(sp.y-xy.y)) < rho) gl_FragColor = vec4(0);
  xy = vec2(sin( k.x * (xy.x+xy.y) ), sin( k.y * (xy.y - xy.x) ));
 }

}