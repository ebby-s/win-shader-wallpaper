precision highp float;
uniform vec2 resolution;
uniform float time;

float e(vec3 c, float r)
{
  c = cos(vec3(cos(c.x)*c.x-cos(c.y)*c.y,c.z/14.*c.z,c.x+c.z+c.y+r));
  return c.x*c.x*c.x*c.x+c.y*c.y*c.y+c.z*c.z*c.z-0.1;
}

void main()
{

 vec2 c = (gl_FragCoord.xy * 2.0 - resolution) / resolution;
  vec3 o=vec3(0.),g=vec3(c.x , 1. ,c.y)/24.;
  vec4 v=vec4(0.);
  float t=time/9.,i,ii;
  for(float i=0.;i<600.;i+=1.0)
    {
      vec3 vct = g*i;
      float scn = e(vct, t);
      if(scn<.4)
        {
          break;
        }
        ii=i;
    }
  gl_FragColor=vec4((ii/1000.));
}