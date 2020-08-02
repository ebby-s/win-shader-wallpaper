#ifdef GL_ES
precision highp float;
#endif

#extension GL_OES_standard_derivatives : enable
const int steps=50;
const float threshold=0.01;
const int slices=4;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
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
float cubeSD(vec4 pt,float s){
  return max(max(abs(pt.x),abs(pt.y)),max(abs(pt.z),abs(pt.w)))-s;
}
float sphereSD(vec4 pt,float s){
  return length(pt)-s;
}
float unionSD(float a,float b){
  return min(a,b);
}
float subSD(float a,float b){
  return max(a,-b);
}
float DE(vec4 z)
{
 vec4 a1 = vec4(1,1,1,1);
 vec4 a2 = vec4(-1,-1,1,1);
 vec4 a3 = vec4(1,-1,-1,1);
 vec4 a4 = vec4(-1,1,-1,1);
 vec4 a5 = vec4(1,1,1,-1);
 vec4 a6 = vec4(-1,-1,1,-1);
 vec4 a7 = vec4(1,-1,-1,-1);
 vec4 a8 = vec4(-1,1,-1,-1);
 vec4 c;
 float dist, d;
 float Scale=2.0;
 for(int n=0;n<10;n++){
   c = a1; dist = length(z-a1);
         d = length(z-a2); if (d < dist) { c = a2; dist=d; }
   d = length(z-a3); if (d < dist) { c = a3; dist=d; }
   d = length(z-a4); if (d < dist) { c = a4; dist=d; }
   d = length(z-a5); if (d < dist) { c = a5; dist=d; }
   d = length(z-a6); if (d < dist) { c = a6; dist=d; }
   d = length(z-a7); if (d < dist) { c = a7; dist=d; }
  z = Scale*z-c*(Scale-1.0);
 }

 return length(z) * pow(Scale, float(-10));
}
float sceneSD(vec4 pt){
 return DE(pt);//max(sphereSD(pt-vec4(0.0,0.0,0.0,0.0),0.5),cubeSD(pt-vec4(0.0,0.0,0.0,0.0)-vec4(0.5),0.5));
  /*return min(min(cubeSD(pt,1.0),cubeSD(pt-vec4(0.0,-4.0,0.0,0.0),0.5)),
  max(sphereSD(pt-vec4(0.0,-2.0,0.0,0.0),0.5),cubeSD(pt-vec4(0.0,-2.0,0.0,0.0)-vec4(0.5),0.5))
  );*/
}
void main( void ) {

 vec2 position = (( gl_FragCoord.xy / resolution.xy )-vec2(0.5))*resolution.xy/resolution.y*1.0;
 vec2 screen=floor(position);
 //position=mod(position+vec2(1.0),vec2(2.0))-vec2(1.0);
  vec3 totColor=vec3(0.0);
  //for(int i=-slices;i<=slices;i++){
      vec2 voxelScreen=vec2(position.x,position.y);
      
      vec4 pos=normalize(vec4(sin(time),cos(time*5.0),-7.0*sin(time*2.0),10.0*cos(time*3.0)))*20.0;
   vec4 up=vec4(0.0,1.0,0.0,0.0);
   vec4 right=vec4(1.0,0.0,0.0,0.0);
   vec4 ray=normalize(-pos);
   ray=normalize(ray+ray.zwyx*normalize(vec4(-sin(mouse.x),sin(mouse.x),-cos(mouse.x),cos(mouse.x)))*position.y+ray.wzxy*normalize(vec4(sin(mouse.x),sin(mouse.x),cos(mouse.x),cos(mouse.x)))*position.x);
      vec3 color=vec3(0.0,0.0,0.0);
      bool hit=false;
      for(int r=0;r<steps;r++){
        float d=sceneSD(pos);

        if(sceneSD(pos)<threshold){
          color=hsv2rgb(vec3((mod(pos.x,1.0)+mod(pos.y,1.0)/2.0+mod(pos.z,1.0)/4.0+mod(pos.w,1.0)/8.0)/2.0,1.0,0.5));//vec3(sin(pos.x)/2.0+0.5,sin(pos.w)/2.0+0.5,(sin(pos.y)/2.0+0.5+cos(pos.z)/2.0+0.5)/2.0);
          hit=true;
          break;
        }
        pos+=ray*d;
      }
      if(hit){
        totColor+=color/1.0;//(1.0+2.0*float(slices));
        //break;
      }
  //}
  gl_FragColor=vec4(totColor,1.0);


}
