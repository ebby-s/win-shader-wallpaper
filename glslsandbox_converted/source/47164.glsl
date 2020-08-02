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
 p.x-=time*100.;
 p *= .3;
 float s = sin(p.x*.13-time*0.5)*sin(p.y*0.19+sin(time*1.5));
 float t = sin(p.x*.27+time*3.2)*sin(p.y*0.11-s+sin(time*0.9));
 float f = (s+t);
 //gl_FragColor = vec4(f,f-t,t-f,1)/2.0;
 //gl_FragColor = vec4(t,f,s,1)/2.0;
 gl_FragColor = vec4(f,t,s,1)/2.0;
}