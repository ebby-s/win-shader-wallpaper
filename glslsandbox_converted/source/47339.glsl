#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
 
// vec2 s = sin(gl_FragCoord.xy*mouse);
 vec2 p = gl_FragCoord.xy;
 p *= .2;
 float s = sin(p.x*0.07+time*3.0)*sin(p.y*0.09+time*1.2);
 float t = sin(p.x*0.13-time*1.1-s)*cos(p.y*0.053-time*1.3+s);
 float f = (s+t);
 //gl_FragColor = vec4(f,f-t,t-f,1)/2.0;
 //gl_FragColor = vec4(t,f,s,1)/2.0;
 gl_FragColor = vec4(f,t,s,1)/2.0;
}