#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// Bonzomatic's default shader translated to glsl sandbox format


float fGlobalTime = time; // in seconds
vec2 v2Resolution = resolution; // viewport resolution (in pixels)

vec4 out_color;

const float hit = 0.000001;
float t = fGlobalTime;



vec3 lipo = vec3(2.0 + sin(t * 1.2) * 14.0, 22.0, -2.0),
 lico = vec3(0.8, 0.2, 1.0);

float obj(vec3 p)
{
 return length(p) - 4.0;
}

float sphere(vec3 p, float r)
{
 return length(p) - r;
}

float df(vec3 p)
{
 float r = 9999999.0;
 
 const float num = 4.0;
 for (float i=0.0;i<num; i += 1.0) {
  float x = sin(t + i * 3.1 / num) * 5.0, z = cos(t+i) * 5.0;
  r = min(r, sphere(p - vec3(x, sin(t + i * 1.5) + 2.0, 15.0 + z), 1.0 + sin(i+t) * 0.5));
 }
 r = min(r, obj(p - vec3(0.0, -4.0, 15.0)));
 return r;
}


float shade(vec3 p)
{
 float r = 1.0;
 

 vec3 rd = normalize(lipo - p);
 p += rd * 1.0;
 
 for (float i = 0.0; i < 15.0; i += 1.0) {
  float d = df(p);
  if (d < 0.0) { p += d * rd; d = 0.0; }
   
  if (d < 1.0) {
   r *= d;
  }
  else
  { p += d * rd * 0.9; }
 }
  
 return r;
}

void main(void)
{
      vec2 uv = vec2(gl_FragCoord.x / v2Resolution.x, gl_FragCoord.y / v2Resolution.y);
      uv -= 0.5;
      uv /= vec2(v2Resolution.y / v2Resolution.x, 1);

  vec3 ro = vec3(0.), sp = vec3(uv, 1.0), rd = normalize(sp-ro), 
   p = ro;


 vec3 l = vec3(0.0);
 float contrib = 1.0;
 
 for (float i = 0.0; i < 100.0; i += 1.0) {
  float d = df(p);
  if (d < 0.0) { p += d * rd; d = 0.0; }
   
  if (d < hit) {
   vec3 e = vec3(0.001, 0.0, 0.0);
   vec3 norm = normalize(vec3(df(p-e.xyy), df(p-e.yxy), df(p-e.yyx)));
   vec3 lv = normalize(p - lipo);
   
   l = (1.0 - contrib) * l + (dot(lv, norm) * lico * shade(p) * 4.0 + vec3(0.1, 0.01, 0.05)) * contrib;   
   contrib *= 0.8;
   
   if (contrib < 0.1) break;
   rd = reflect(rd, norm);
   p += rd * 0.001;
   
  }
  else
  { p += d * rd * 0.9; }
  
  if (length(p) > 100.0) break;
 }
 
 
      out_color = vec4(l, 0.0);

  
      gl_FragColor = out_color;
}