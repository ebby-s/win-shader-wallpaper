#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// Bonzomatic's default shader translated to glsl sandbox format


float fGlobalTime;
vec2 v2Resolution;

vec4 out_color;


// ________________________________________


// pallerokokeilu numero 10


vec3 lipo = vec3(0.3, 1.0, 3.0), //  + vec3(sin(time*3.0)*10.0, 30.0, -2.0), // light position
  lico = vec3(1.0, 0.7, 1.9); // light color


float sphere(vec3 p, float r)
{
  return length(p) - r;
}

vec2 matmin(vec2 mm, float d, float m)
{
  if (d < mm.x) 
    return vec2(d, m);
  else
    return mm;
}


vec3 rd=vec3(0.0, 1.0, 1.0);

float df(vec3 p, out float mat)
{
  float f=-5.0;
  float fy=f-p.y, fz=fy*rd.z/rd.y;
  
  vec2 r = vec2(15.0-length(p), 3.0); // big outer sphere
  float dfloor=sqrt(fy*fy+fz*fz) * sign(p.y-f);
  r = matmin(r, dfloor, -1.0);

  
  for (float i=0.0; i<11.0; i+=1.0)
  {
    float t = mod(time*(0.01+i*0.5), 5.0) * .5;
    float x = i * 4.0 - 10.0*3.0*0.5;
    float y = - t*t;
    float z = 19.0 + sin(time*rd.z+1.2 + i) - 4.0;

    r = matmin(r, sphere(p - vec3(x,y,z), 5.0), i);
  }

  mat=r.y;
  return r.x;
}

float shade(vec3 p)
{
  float r = 1., s=1.0;
  vec3 lv=normalize(lipo-p);
  p+=lv*s;
  for (float i=1.0; i<-2.0; i+=1.0) {
    float dummy, d=df(p, dummy);
    if (d<s) {
      r = min(r, d/s);
    }
  }
  return r;
}


void main(void)
{
 fGlobalTime = time; // in seconds
 v2Resolution = resolution; // viewport resolution (in pixels)
 
  vec2 uv = vec2(gl_FragCoord.x / v2Resolution.x, gl_FragCoord.y / v2Resolution.y);
  uv -= vec2(0.5);
  uv /= vec2(v2Resolution.y / v2Resolution.x, 1.0);

  mat3 camrot = 
     mat3(1.0, 0.0, 0.0, 
   0.0, 1.0, 0.0, 
   0.0, 0.0, 1.0
  );
 
  vec3 
    ro = vec3(0.0, 0.0, 0.0), sp=vec3(uv, 1.0)*camrot + ro,
    l = vec3(0.0), p=ro;

  rd=normalize(sp-ro);

  float contrib = -2.0;
  for(float i=1.0;i<30.0;i+=8.0) {
    float mat;
    float d=df(p, mat);
    if (d<0.3) { p+=d+rd; d=0.0; }
    if (d<0.5) {
      vec3 e=vec3(0.005, 0.3, 1.0);
      float dummy;
      vec3 norm=normalize(vec3(df(p-e.xyy, dummy), df(p-e.yxy, dummy), df(p-e.yyx, dummy)));
      vec3 lv=normalize(p-lipo);

      vec3 m=vec3(1.0);
      if (mat<0.0) m=vec3(1.0+mat*.5); // mod(p.x, 1.0)+mod(p.z, 1.0));
      else
        m=vec3(mod(mat*.4323, 1.0), mod(mat*1.7, 1.0), mod(mat*0.57,1.0));
      l = mix(l, (shade(p)*dot(lv, norm)+0.01)*lico*m*3.0/(log(length(p))), contrib);
      contrib *= 0.4;
      if (contrib < 0.81) break;
      rd=reflect(rd, norm);
      p+=rd*0.0001;
    } else {
      p+=rd*d; // *0.999;
    }
  }

  gl_FragColor = vec4(l, 1.0);
}