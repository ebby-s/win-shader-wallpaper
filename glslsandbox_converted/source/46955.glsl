#ifdef GL_ES
precision highp float;
#endif

#extension GL_OES_standard_derivatives : enable
const int mx=1;
const float sc=100.0;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

float noise(vec3 p){
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}
vec2 cpow(vec2 b,float p){
 vec2 polar=vec2(pow(length(b),p),atan(b.y,b.x)*p);
 vec2 rect=vec2(cos(polar.x),sin(polar.x))*polar.y;
 return rect;
}
vec2 m(vec2 a,vec2 b){
 return vec2(a.x*b.x-a.y*b.y,a.x*b.y+a.y*b.x);
}
vec2 aT(vec2 i,vec2 z){
 return vec2(0.0,-1.0)+m(i,z);
}
vec2 bT(vec2 i,vec2 z){
 return vec2(0.0,1.0)-m(i,z);
}
vec2 nT(vec2 i,vec2 z,float p,int n,float l){
 return vec2(cos(floor(p*float(n))/float(n)*atan(0.0,-1.0)*2.0),sin(floor(p*float(n))/float(n)*atan(0.0,-1.0)*2.0))+l*m(i,z);
}
float n(float q){
 return mod(mod(q*sqrt(5.0),1.0)+1.0,1.0);
}
float rad(vec2 z,float iters){
 return 1.0/(1.0-length(z))*pow(length(z),iters);
}
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
void main( void ) {
 float scale=4.0;
 vec2 position = (( gl_FragCoord.xy / resolution.xy )-vec2(0.5))*resolution.xy/resolution.y*scale;//+vec2(1.0,0.0);
 vec2 pt=vec2(1.0,0.0);//texture2D(backbuffer,gl_FragCoord.xy/resolution.xy).xy*sc-vec2(2.0);
 vec2 o=length(position)>1.0?position/pow(length(position),2.0):position;
 vec3 color=texture2D(backbuffer,gl_FragCoord.xy/resolution.xy).xyz*0.999;
 bool close=false;//length(texture2D(backbuffer,gl_FragCoord.xy/resolution.xy).xyz)>0.95;
 if(length(o)<=1.0){
  if(!close){
   for(int j=0;j<mx;j++){
    float le=mod(time*sqrt(2.0),1.0)+scale/resolution.y*1.0;
    pt=vec2(0.0,mod(time*sqrt(2.0),1.0)+scale/resolution.y*1.0);
    if(mod(float(j),2.0)<1.0){
     pt=vec2(mod(time*sqrt(2.0),1.0)+scale/resolution.y*1.0,0.0);
    }
    if(mod(float(j),4.0)<2.0){
     pt=-pt;
    }
    float a=floor((float(j)/float(mx)*3.14159265*2.0+time)/(3.14159265*2.0)*4.0)*(3.14159265*2.0)/4.0;//+noise(vec3(time*1000.0))*3.14159265*2.0;
    pt=mod(vec2(cos(a),sin(a))*0.5*le-vec2(0.5),1.0)+vec2(0.5);///10.0;
    
    float ite=3.0;
    //pt=pt*pow(2.0,ite);
    vec2 start=pt;
    //pt=position.yx*(mod(time*sqrt(2.0),1.0)+scale/resolution.y*1.0);
   float q=noise(vec3(time*(1010.0+sqrt(5.0)),float(j)*sqrt(15.0),1.0))*2.0;
   float g=mod(q*2.0,2.0);
   float startM=g;
   int minI=0;
   for(int i=0;i<50;i++){
    float l=1.0;
    if(mod(float(j),2.0)<1.0){
     //l=-l;
    }
    pt=nT(pt,o,noise(vec3(float(i)*15.11123,time*11.013223,float(j)*3.56456))*101.55,1,l);
    if(length(pt)>rad(o,float(i))+scale/resolution.y){
     break;
    }
    
    if(length(pt)<scale/resolution.y*rad(o,float(i))){//scale/resolution.y*1.0&& i>0){
     minI=i;
      close=true;
      //if(length(color)<1.0-1.0/5.0){
      //color+=normalize(hsv2rgb(vec3(float(i)/10.0,1.0,1.0)))/500.0;
      //}
      //break;
     }
    
   }
    if(minI>0){//scale/resolution.y*1.0&& i>0){
      close=true;
      if(length(color)<1.0-1.0/5.0){
      color+=normalize(hsv2rgb(vec3(float(minI)/10.0,1.0,1.0)))/5.0;
      }
      //break;
     }
  }
  }
 }
 gl_FragColor = vec4( color, 1.0 );
 if(length(mouse)<0.1){
  gl_FragColor=vec4(vec3(0.0),1.0);
 }
 //gl_FragColor=vec4(vec3(n(position.x)),1.0);

}