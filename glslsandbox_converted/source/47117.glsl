#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
 vec2 p = (gl_FragCoord.xy*0.5-resolution)/min(resolution.x,resolution.y);
 float ratio = (resolution.y)/(resolution.x);
 vec2 p0 = p + vec2((time + 300000.)/3.0);
 vec2 q = mod(p0,0.2)-0.1;
 vec2 r = vec2(p.x*ratio/2.0+0.5,p.y/2.0+0.5);
 float f = 0.0002 / (abs(q.y) * abs(q.x));
 float t1 = cos(time)/2.2+0.5;
 float t2 = sin(time)/2.2+0.5;
 gl_FragColor = vec4(vec3(f*t2,f*r.x*t1*t2,f*r.y*r.x), 1.0);
}