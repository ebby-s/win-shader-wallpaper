#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define sqr(x) (x*x)

float mandelbrot( in vec2 p, in vec2 c ) {
 for(float i = 0.; i<1.; i += 1./256.) {
  p = vec2(sqr(p.x)-sqr(p.y), 2.*p.x*p.y)+c; 
  if(length(p)>4.) return i;
 }
 return 0.;
} 

void main( void ) {
 vec2 p = (2.*gl_FragCoord.xy - resolution.xy) / resolution.y;
 
 
 // mandelbrot
 //gl_FragColor = vec4(mix(vec3(.15, .135, .176), vec3(.95, .73, .8), mandelbrot(vec2(0), 1.375*p)), 1);
 // julia
 gl_FragColor = vec4(mix(vec3(.15, .135, .176), vec3(.95, .73, .8), mandelbrot(1.375*p, vec2(.36, .36))), 1);
}