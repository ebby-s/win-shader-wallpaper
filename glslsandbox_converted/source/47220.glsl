precision highp float;
uniform vec2 resolution;
uniform float time;

float e(vec3 c, float r)
{
  c = cos(vec3(cos(c.r+r/5.)*c.r-cos(c.g+r/7.)*c.g,c.b/3.*c.r-cos(r/5.1)*c.g,c.r+c.g+c. b+r));
  return dot(c*c,vec3(2.))-1.0;
}

void main()
{
  vec2 c=-1.+2.0*gl_FragCoord.rg/resolution.xy;
  vec3 o=vec3(0.),g=vec3(c.r,c.g,1)/64.;
  vec4 v=vec4(0.);
  float t=time/3.,i,ii;
  for(float i=1.;i< 666.;i+=1.0)
    {
      vec3 vct = o+g*i;
      float scn = e(vct, t);
      if(scn<.4)
        {
          vec3 r=vec3(.3,0.,0.3),c=r;
          c.r=scn-e(vec3(vct+r.rgg), t);
          c.g=scn-e(vec3(vct+r.grg), t);
          c.b=scn-e(vec3(vct+r.ggr), t);
          v+=dot(vec3(0.,0.,-1.0),c)+dot(vec3(0.0,-0.5,0.5),c);
          break;
        }
        ii=i;
    }
  gl_FragColor=v+vec4(.1+cos(t/14.)/9.,0.1,.1-cos(t/3.)/19.,1.)*(ii/44.);
}