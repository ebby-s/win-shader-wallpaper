#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float fGlobalTime = time; // in seconds
vec2 v2Resolution = resolution; // viewport resolution (in pixels)


const float hit = 0.000001;

float sphere(vec3 p, vec3 c, float r)
{
  return distance(p, c) - r;
}


float df(vec3 p)
{
  float d = 999990.0;
  for (float i= 0.0; i<5.0; i+=1.0) {
     float r=5.0, t=fGlobalTime+i, x=sin(t)*r, y=sin(t*1.7)*2.0,  z=cos(t)*r;
     d = min(
           d, 
           sphere(p, vec3(x, y, z + 25.0 + sin(fGlobalTime)*2.0), 2.0)
         );
  }
  return d;
}

 vec3 lipo = vec3(2.0 + sin(fGlobalTime)*2.0, 20.0, -3.0),
      lico = vec3(1.0, 0.8, sin(fGlobalTime*3.0)*0.5 + 0.5);


void main(void)
{
  vec2 uv = vec2(gl_FragCoord.x / v2Resolution.x, gl_FragCoord.y / v2Resolution.y);
  uv -= 0.5;
  uv /= vec2(v2Resolution.y / v2Resolution.x, 1);

  vec3 ro = vec3(0.0), sp=vec3(uv, 2.0);
  vec3 rd = normalize(sp-ro);

  vec3 p = ro;
  vec3 l = vec3(0.0);
  float contr = 1.0;
  for (float i=0.0; i<109.0; i+=1.0) {
    float d = df(p);
   
    if (d < 0.0) { p += rd * d; d = 0.0; }
   
    if (d < hit) {
      vec3 ld = normalize(p - lipo);
      vec3 eps3 = vec3(0.0001, 0.0, 0.0);
      vec3 norm = normalize(vec3(df(p-eps3.xyy), df(p-eps3.yxy), df(p-eps3.yyx)));

      l = l * (1.0 - contr) + (dot(ld, norm) * lico) * contr;
      contr *= 0.8;  

      if (contr < 0.1) 
        break;
      rd = reflect(rd, norm);
      p += rd * 0.001;
    }
 else
    p += d * rd * 0.9;
  }

  gl_FragColor = vec4(l, 0.0);
}