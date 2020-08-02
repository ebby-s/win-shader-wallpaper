/*
 * Original shader from: https://www.shadertoy.com/view/XdcGzH
 */

#extension GL_OES_standard_derivatives : enable

#ifdef GL_ES
precision mediump float;
#endif

// glslsandbox uniforms
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
// shadertoy globals
float iTime;
vec3  iResolution;
const float e = 2.71828183;
// Protect glslsandbox uniform names
#define time        stemu_time
#define resolution  stemu_resolution

// --------[ Original ShaderToy begins here ]---------- //
//Public domain
#define PI 3.14159
#define A2B PI/360.
#define MaxIter 15
#define ScaleF 3.5
#define SquareLoop 1

vec2 c_mul(vec2 c1, vec2 c2)
{
 float a = c1.x;
 float b = c1.y;
 float c = c2.x;
 float d = c2.y;
 return vec2(a*c - b*d, b*c + a*d);
}



float color(vec2 z, vec2 c) {
 float res = 1.0;
 for (int i=0; i < MaxIter;i++) {
  for (int o = 0; o < SquareLoop;o++)
   z = c_mul(z,z);
  
  z += c;
  if (length(z) > 4.0) {
   res = float(i)/float(MaxIter);
   break;
  }
 }
 return (res);
}

float Box(vec2 z, vec2 c) {
 float res = color(z,c);
 bool flag = false;
 for(float x= -1.; x <= 1.; x+=1.0) {
  for(float y = -1.0;y <= 1.0;y+=1.0) {
   float tmp = color(z+vec2(x,y)*0.002,c);
   if (tmp != res) {
    flag = true;
    break;
   }     
  }
  if (flag)
   break;
 }
 if (flag)
  return(0.0);
 else
  return(1.0);

}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
 vec2 c = (mouse.xy - vec2(0.5,0.5))*2. + vec2(cos(iTime*0.8),sin(iTime*0.568))*0.01;
 
 vec2 uv = ScaleF*(fragCoord.xy-0.5*iResolution.xy) / iResolution.x;
    uv.y+=0.;
 
 float p = Box(uv,c);//color(uv,c);
 fragColor = vec4(p, p, p, 1.0);
}


#undef time
#undef resolution

void main(void)
{
  iTime = time;
  iResolution = vec3(resolution, 0.0);

  mainImage(gl_FragColor, gl_FragCoord.xy);
}