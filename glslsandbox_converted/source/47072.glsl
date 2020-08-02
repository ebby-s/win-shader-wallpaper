#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;
uniform vec2 surfaceSize;
uniform sampler2D sampler2d;
// https://math.stackexchange.com/questions/2654984/identifying-this-chaotic-recurrence-relation

void main( void ) {
 
 gl_FragColor = vec4( 1.0 );
 
 float rho = 3.33/max(resolution.x, resolution.y);
 
 vec2 xy = (mouse-.5)*7. + vec2(cos(time*12.), sin(time*12.))*rho;
 vec2 k = xy;
 vec2 sp = 2.5*surfacePosition;
 
 if(max(abs(sp.x), abs(sp.y)) > 1.){
  gl_FragColor = vec4(0.5); 
 }
 
 for(float i = 0.; i <= 99.; i += 1.){
  if(max(abs(sp.x-xy.x), abs(sp.y-xy.y)) < rho){
   gl_FragColor = vec4(0.0,0.333,0.5,1.);
   break;
  }
  xy = vec2(sin( k.x * (xy.x+xy.y) ), sin( k.y * (xy.y - xy.x) ));
 }
 
 gl_FragColor = min(texture2D(sampler2d, gl_FragCoord.xy/resolution)+1./256., gl_FragColor);

}