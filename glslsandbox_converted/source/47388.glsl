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
#define MaxIter 14
float c_abs(vec2 c)
{
 return sqrt(c.x*c.x + c.y*c.y);
}
vec2 c_pol(vec2 c)
{
 float a = c.x;
 float b = c.y;
 float z = c_abs(c);
 float f = atan(b, a);
 return vec2(z, f);
}
vec2 c_rec(vec2 c)
{
 float z = abs(c.x);
 float f = c.y;
 float a = z * cos(f);
 float b = z * sin(f);
 return vec2(a, b);
}

vec2 c_mul(vec2 c1, vec2 c2)
{
 float a = c1.x;
 float b = c1.y;
 float c = c2.x;
 float d = c2.y;
 return vec2(a*c - b*d, b*c + a*d);
}

vec2 c_pow(vec2 base, vec2 expo)
{
 vec2 b = c_pol(base);
 float r = b.x;
 float f = b.y;
 float c = expo.x;
 float d = expo.y;
 float z = pow(r, c) * pow(e, -d * f); 
 float fi = d * log(r) + c * f;
 vec2 rpol = vec2(z, fi);
 return c_rec(rpol);
}

float color(vec2 z, vec2 c) {
 float res = 1.0;
 for (int i=0; i < 50;i++) {
  for (int o = 0; o < 1;o++)
   z = c_mul(z,z);
  z += c;
  if (length(z) > 4.0) {
   res = float(i)/50.;
   break;
  }
 }
 return (res);
}
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
 vec2 c = (mouse.xy - vec2(0.5,0.5))*3. + vec2(cos(iTime*0.8),sin(iTime*0.568))*0.01;
 float scaleFactor=3.0;
 vec2 uv = scaleFactor*(fragCoord.xy-0.5*iResolution.xy) / iResolution.x;
    uv.y+=0.;
 
 float p = color(uv,c);
 fragColor = vec4(p, p, p, 1.0);
}
// --------[ Original ShaderToy ends here ]---------- //

#undef time
#undef resolution

void main(void)
{
  iTime = time;
  iResolution = vec3(resolution, 0.0);

  mainImage(gl_FragColor, gl_FragCoord.xy);
}