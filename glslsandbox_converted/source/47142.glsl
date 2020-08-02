#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI  = 3.141592653589793;
const float PI2 = PI * 2.;

#define s(x) clamp(x,0.,1.)
#define _G sG()
#define _L sL()
#define _S sS()
#define _C sC()
#define _H sH()
#define _O sO()
#define _D sD()
#define _U sU()
#define _T sT()
#define _2 s2()
#define _1 s1()
#define _8 s8()

vec2 pos;

float slice(float x,float start,float end){
     return step(start,x)*step(x,end)*x;
}

float tslice(float x,float start,float end){
     return 1.-step(step(start,x)*step(x,end)*x,0.);
}

float sqr(float x){
   return -2.*(step(.5,fract(x*.5))-.5);
}

mat2 rotate2d(float a){
 float c=cos(a);
 float s=sin(a);
 return mat2(c,-s,s,c);
}

float fill(float d,float r){return step(0.,r - d);}
float lBox(vec2 p){return max(abs(p.x),abs(p.y));}
float sBox(vec2 p,float r){return fill(lBox(p),r);}
float lRect(vec2 p, vec2 size) {  
  vec2 d = abs(p) - size;
  return min(max(d.x, d.y), 0.0) + length(max(d,0.0));
}
float sRect(vec2 p,vec2 size){return fill(lRect(p,size),0.);}
void i(){pos.x-=2.;}
void cr(float x){pos.x=x+2.;pos.y+=2.;}
float sG(vec2 p){
 return s(s(sBox(p,.6)-sBox(p,.4))
 +sRect(p-vec2(.2,0)  ,vec2(.2,.1))
 -sRect(p-vec2(.5,.25),vec2(.1,.15)));}
float sL(vec2 p){return s(sBox(p,.6)-sBox(p-.2,.6));}
float sS(vec2 p){
 return s(sBox(p,.6)
 -sRect(p-vec2( .1, .25),vec2(.5,.15))
 -sRect(p-vec2(-.1,-.25),vec2(.5,.15)));
}
float sC(vec2 p){
 return s(sBox(p,.6)
 -sRect(p-vec2(.1,0.),vec2(.5,.4)));
}
float sO(vec2 p){return s(sBox(p,.6)-sBox(p,.4));}
float sH(vec2 p){
 return s(sBox(p,.6)
        -sRect(p+vec2(0.,-.35),vec2(.4,.25))
 -sRect(p+vec2(0.,+.35),vec2(.4,.25)));
}
float sD(vec2 p){return s(sBox(p,.6)-sBox(p,.4));}
float sU(vec2 p){
 return s(sBox(p,.6)
     -sRect(p+vec2(0.,-.35),vec2(.4,.75)));
}
float sT(vec2 p){
 return s(sBox(p,.6)
        -sRect(p+vec2(-.5,+.15),vec2(.4,.5))
 -sRect(p+vec2(0.5,+.15),vec2(.4,.5)));
}
float s1(vec2 p){return sRect(p-vec2(0,0),vec2(.1,.6));}
float s2(vec2 p){return sS(vec2(-p.x,p.y));}
float s8(vec2 p){
 return s(sBox(p,.6)
 -sRect(p-vec2( .0, .25),vec2(.4,.15))
 -sRect(p-vec2(-.0,-.25),vec2(.4,.15)));
}

float sG(){i();return sG(pos);}
float sD(){i();return sD(pos);}
float sU(){i();return sU(pos);}
float sT(){i();return sT(pos);}
float sL(){i();return sL(pos);}
float sS(){i();return sS(pos);}
float sC(){i();return sC(pos);}
float sO(){i();return sO(pos);}
float sH(){i();return sH(pos);}
float s2(){i();return s2(pos);}
float s1(){i();return s1(pos);}
float s8(){i();return s8(pos);}

float layerGDUTSCHOOL2018(vec2 p){
   p.x+=1.;
   p.y-=.4;
   p*=6.;
   p.x-=1.;
   pos=p;
   pos.x+=2.;
   float l;
   l+=_G+_D+_U+_T;cr(p.x);
   l+=_S+_C+_H+_O+_O+_L;cr(p.x);
   l+=_2+_O+_1+_8;cr(p.x);
   return s(l);
}

vec2 transitionZoomIn(  vec2 p,float t){ return p*clamp(t,0.,1.);}
vec2 transitionZoomOut( vec2 p,float t){ return p*clamp(1.-t,0.,1.);}
vec2 effectPixelate(    vec2 p,float t){ return floor(p*pow(2.,t*5.))/pow(2.,t*5.);}
vec2 effectRotateGlicth(vec2 p,float t){
   p*=rotate2d(t*5.);
   p.y+=sqr(p.x*10.)*sin(t)*.01;
   p*=rotate2d(-t*5.);
   return p;
}

vec2 effectProlongPolar(vec2 p,float t){
   float a = mod((atan(p.y,p.x) + PI2 + clamp(t*PI*.5,0.,PI2)),PI2);
   float r = length(p);
   r=min(r,t/5.);
   return vec2(r*cos(a),r*sin(a));
} 

vec2 effectProlongX(vec2 p,float t){
   p.x=sign(p.x)*min(abs(p.x),t/5.);
   return p;
} 

float maskRadar(vec2 p,float t){
   float a = mod((atan(p.y,p.x) + PI2 - t),PI2);
   return 1.-a/PI2;
} 

vec3 layerFakeChromaticAberration(vec2 p,float t){
   float l=layerGDUTSCHOOL2018(p);
   float purple=layerGDUTSCHOOL2018(p+vec2(.005+.005*sin(p.y*30.+t*10.),0.));
   float green =layerGDUTSCHOOL2018(p-vec2(.005+.005*cos(p.y*30.+t*10.),0.));
   return vec3(.8,.5,1.)*purple+vec3(.5,1.,.5)*green+vec3(l); 
}

vec3 scene1(vec2 p,float t){
   p=transitionZoomIn(p,t);
   return layerFakeChromaticAberration(p,t);
} 

vec3 scene2(vec2 p,float t){
   vec2 o = transitionZoomOut(p,t);
   return layerFakeChromaticAberration(o,t)*(1.-t)+layerFakeChromaticAberration(p,t);
} 

vec3 scene3(vec2 p,float t){
   p=effectRotateGlicth(p,t);
   return layerFakeChromaticAberration(p,t);
} 

vec3 scene4(vec2 p,float t){
   p=effectPixelate(p,fract(t));
   return layerFakeChromaticAberration(p,t);
} 

vec3 scene5(vec2 p,float t){
   p=effectRotateGlicth(p,t);
   p=effectProlongX(p,t);
   p=effectProlongPolar(p,t);
   return layerFakeChromaticAberration(p,t);
} 

vec3 scene6(vec2 p,float t){
   return layerFakeChromaticAberration(p,t)*maskRadar(p,t);
} 

void main(void){
   vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x, resolution.y);
   vec3 color = vec3(0.,0.,0.);
 
   float t = mod(time,16.);
   float tc = 0.;
   float ti;
   ti=1.;color+= tslice(t,tc,tc+ti) * scene1(p,t-tc);tc+=ti;
   ti=1.;color+= tslice(t,tc,tc+ti) * scene2(p,t-tc);tc+=ti;
   ti=1.;color+= tslice(t,tc,tc+ti) * scene3(p,t-tc);tc+=ti;
   ti=1.;color+= tslice(t,tc,tc+ti) * scene4(p,t-tc);tc+=ti;
   ti=6.;color+= tslice(t,tc,tc+ti) * scene5(p,t-tc);tc+=ti;
   ti=6.;color+= tslice(t,tc,tc+ti) * scene6(p,t-tc);tc+=ti;
 
   gl_FragColor = vec4(color, 1.0);
}
