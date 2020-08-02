//--- hatsuyuki ---
// by Catzpaw 2016
#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float snow(vec2 uv,float scale)
{
 float w=smoothstep(1.,0.,-uv.y*(scale/10.));if(w<.1)return 0.;
 uv+=time/scale;uv.y+=time*2./scale;uv.x+=sin(uv.y+time*.5)/scale;
 uv*=scale;vec2 s=floor(uv),f=fract(uv),p;float k=3.,d;
 p=.5+.35*sin(11.*fract(sin((s+p+scale)*mat2(7,3,6,5))*5.))-f;d=length(p);k=min(d,k);
 k=smoothstep(0.,k,sin(f.x+f.y)*0.01);
     return k*w;
}