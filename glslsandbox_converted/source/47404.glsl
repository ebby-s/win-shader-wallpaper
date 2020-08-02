#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define R(v) mod(v+1.,2.)-1.
void main(){vec2 r = resolution,u=(2.*gl_FragCoord.xy-r)/r.y;vec3 o=vec3(1.,0.,time/3.),d=vec3(u,1.),p;float t=0.;for (int i=0;i<32;i++){p=o+d*t;p.y*=.01;t+=.5*(length(R(p))-.2);}gl_FragColor=vec4((u.y+1.)*vec3(1./t),.1);}