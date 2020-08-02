#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;
uniform vec2 surfaceSize;

// https://math.stackexchange.com/questions/2654984/identifying-this-chaotic-recurrence-relation

#define N 500.0

void main( void ) {
 
 gl_FragColor = vec4( 1.0 );
 
 float rho = 5./max(resolution.x, resolution.y);
 
 vec2 k = 8.*(mouse-.5);
 vec2 xy = vec2(sin(time*80.),cos(time*93.));
 vec2 sp = 2.5*surfacePosition;
 
 if(max(abs(sp.x), abs(sp.y)) > 1.){
  gl_FragColor = vec4(0.5); 
 }
 else
  gl_FragColor = vec4(0.);
 
 float c = 0.;
 for(float i = 0.; i <= N; i += 1.){
  vec2 v = sp-xy;
  float r = .1/dot(v,v);
  if( i > N/10. ) c += r*r;
  xy = vec2(sin( k.x * (xy.x+xy.y) ), sin( k.y * (xy.y - xy.x) ));
 }
 c /= N*N;
 gl_FragColor += vec4(c*.01,c*.1,c,0.);
}