#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

void main( void ) {

 vec2 p = surfacePosition*3.;
 
 float a = atan(p.x,p.y);
 float r = length(p);
 float c = sin(time+r*20.0-cos(a*20.0*sin(r*3.14)));
 gl_FragColor = vec4(0.,c,0.,1.0);

}