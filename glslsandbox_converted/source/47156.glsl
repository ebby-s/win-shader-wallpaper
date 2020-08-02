#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

varying vec2 surfacePosition;
uniform vec2 surfaceSize;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

 float color = 0.0;
 
 color = 1.;
 
 vec2 ph = vec2(sin(time/12.+position.x*2.), sin(time/13. + 3.14159/2.-position.x*3.));
 
 vec2 fx = .67+cos(time/5.+position.x*10.+ph)*0.1;
 if(position.y < ph.y*0.03+fx.x){
  color += 0.1/((position.y + 1./resolution.y)/fx.x);
 }
 if(position.y < ph.x*0.03+fx.y && position.y + 3./resolution.y > ph.x*0.03+fx.y){
  color += 0.1/((position.y + 1./resolution.y)/fx.y);
 }

 gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}