#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define dim 28.0
#define dh dim / 2.0
#define dhm dh - dim / 10.0
#define ood 1.0 / dim
#define mag 1.6 / dim

float linearScale(float n, float min1, float max1, float min2, float max2){
 return ((n - min1) * (max2 - min2)) / (max1 - min1) + min2;
}

bool dir = false;

float cl = 0.05;

float getVal(float val) {
 float f = val;
 f*=time*.002;
 if(f > 0.4) {
  dir = true; 
 }
 if(f < 0.01) {
  dir = false;
 }
 float diff = val - f;
 if(diff < 0.) {
  diff = -diff;
 }
 if(dir == true) {
  return val + diff;
 }else {
  return val + diff;
 }
}

void main( void ) {
 vec2 p = gl_FragCoord.xy / resolution.xy * dim;
 vec3 color = vec3(0.01, 0.01, 0.009);

 float r = p.y * mag + 2.6;
 float t = 0.01;
 float xpt = p.x + t;
 float xmt = p.x - t;
 
 for(float b = 0.0; b < 1.0; b += ood){
  float x = b / dim * abs(cos(time / 1000.0+getVal(time*0.002))) * 10.0;
  
  for(float k = 0.0; k < dh; k++){
   x = r * x * (1.0 - x);
   
   if(k > dhm && x > 0.0){
    float xs = linearScale(x, 0.0, ood, 0.0, 1.0);
   
    if(xs < xpt && xs > xmt){
     float cf = getVal(cl);
     color += cf;
     cl = cf;
    }
   }
  }
 }
 
 color.xz *= mix(color.xy, p, vec2(0.25));

 gl_FragColor = vec4(color, 1.0);
}