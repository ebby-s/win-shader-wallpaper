/*
Eye of Sauron 

Inspired by IQ

Ziad 2/6/2018

Colors can be improved
*/

#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat2 m =mat2(0.8,0.6, -0.6, 0.8);

float rand(vec2 n) { 
 return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float snoise(vec3 uv, float res)
{
 const vec3 s = vec3(1e0, 1e2, 1e3);
 
 uv *= res;
 
 vec3 uv0 = floor(mod(uv, res))*s;
 vec3 uv1 = floor(mod(uv+vec3(1.), res))*s;
 
 vec3 f = fract(uv); f = f*f*(3.0-2.0*f);

 vec4 v = vec4(uv0.x+uv0.y+uv0.z, uv1.x+uv0.y+uv0.z,
           uv0.x+uv1.y+uv0.z, uv1.x+uv1.y+uv0.z);

 vec4 r = fract(sin(v*1e-1)*1e3);
 float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
 
 r = fract(sin((v + uv1.z - uv0.z)*1e-1)*1e3);
 float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
 
 return mix(r0, r1, f.z)*2.-1.;
}

float noise(vec2 n) {
 const vec2 d = vec2(0.0, 1.0);
   vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
 return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}

float fbm(vec2 p){
 float f=.0;
 f+= .5000*noise(p); p*= m*2.02;
 f+= .2500*noise(p); p*= m*2.03;
 f+= .1250*noise(p); p*= m*2.01;
 f+= .0625*noise(p); p*= m*2.04;
 
 f/= 0.9375;
 
 return f;
}


void main( void ) {
 vec2 q = gl_FragCoord.xy/resolution.xy;
 vec2 p = -1.0+ 2.0*q;
 p.x *= resolution.x/resolution.y;
 
 vec3 background=smoothstep(.1,.5,vec3(.9,.4,.4));
 vec3 coord = vec3(sqrt((p.x)*(p.x)/(p.y+.8)/(.8-p.y))/6.2832+.5, length(p)*.4, .5);
 for(int i=0;i<7;i++){
 float power = pow(2.0, float(i));
 background += vec3(0.001)- smoothstep(0.,1.34,(1.5 / power) * snoise(coord + vec3(0.,-time*.05, time*.01), power*16.));
 
 }
 
 float r = sqrt(dot(p,p));
 float a = atan(p.y,p.x);
 float e = sqrt((p.x)*(p.x)/(p.y+.8)/(.8-p.y) );
 
 float f = fbm(4.0*p);
 
 vec3 col = vec3(1.);
 
 float ss=.5+0.5*sin(3.*time);
 float anim =1. + 0.1*ss*clamp(1.-r,.0,1.);
 r*=anim;
 
 if( r<0.8){
  
  col = vec3(.7,0.1,0.1);
  
  float f = 0.4*fbm(20.*p);
  
  col = mix( col, vec3(0.5,0.4,0.3),f);
  
  f = 1.- smoothstep(0.1,0.5,e); 
  col = mix( col, vec3(1.,1.,0.39), f );
  
  a +=.05*fbm(20.0*p);
  
  f = smoothstep( 0.6, 1., fbm(vec2(5.0*e,50.0*a)));
  col = mix(col, vec3 (1.0,.5,.5), f);
  
  f = smoothstep( .1, .9, fbm( vec2(10.*r,15.*a)));
  col *= 1.- .5*f;
  
  f = smoothstep(0.6,0.8, r); 
  col*= .7 - .5*f;
  
  f = smoothstep(0.1,0.15, e); 
  col*= f;
  
  f = smoothstep(.5,.8, r);
  col = mix( col,vec3(1.,.7,.39), f*.5);
  
  f= 1. - smoothstep( .001, .09, length( p- vec2(-0.05,0.3)));
  col += vec3(1.)*f*0.4;
  
  f = smoothstep(.7,.8, r);
  col = smoothstep(.01,.9, mix( col,vec3(2.), .4*f));
  
  
 }
 gl_FragColor=vec4(col*background, 1.);

}