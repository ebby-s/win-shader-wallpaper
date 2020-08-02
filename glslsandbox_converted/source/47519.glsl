#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

void main( void ) {

 vec2 p = surfacePosition*2.;
 
 float a = atan(p.x,p.y);
 float r = length(p);
 float c = sin(time-r*20.0-cos(a*15.0*sin(r*6.14)));
 c *=cos(r*0.9);
 gl_FragColor = vec4(c,c*0.85,c*0.8,1.0);

}