#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 scene_map(vec3 p)
{
    float r = 0.06;
    float angle = time*13.0 + p.x*10.0-p.z*113.0-p.y*12.0;
    float angle2 = time*12.0 + p.x*12.0+p.z*12.0+p.y*13.0;
    p+=vec3(r*sin(angle)*sin(angle2),r*sin(angle)*cos(angle2),r*cos(angle));
    return p;
}


vec4 scene_color(vec3 p)
{
   p=scene_map(p);
   vec3 pp = p-vec3(0.0,0.0,0.0);
 pp=normalize(pp);
 vec3 comp = vec3(-0.8,0.7,-3.0);
 comp=normalize(comp);
        float d = dot(pp,comp);
 vec3 c1 = d*vec3(1.0,0.5,0.0);
 d=pow(d,9.0);
 vec3 c2 = d*vec3(1.0,1.0,1.0);
 vec3 c = c1+c2;
 c = sqrt(c);
    return vec4(c,1.0);
}


float scene(vec3 p)
{
   p=scene_map(p);
 return length(p) - 0.4;
}

vec3 shoot_ray(vec3 r, vec3 d)
{
 float t = 0.0;
 float len = length(d);
 for(int i=0;i<30;i++)
 {
      vec3 p = r+t*d;
      float val = scene(p);
             if (val<=0.0001) return p;
      //val*=1.0;
      t+=val/len;
      if (t>1.0) return p;
 }
 return r+t*d;
}

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.yy );
 position+=vec2(-0.5,-0.5);
 
 vec4 color = vec4(0.0,0.0,0.0,1.0);
        vec3 ray = vec3(position.x, position.y, -100.0);
 vec3 dir = vec3(0.0,0.0,2000.0);
 vec3 p = shoot_ray(ray,dir);
 vec4 c = scene_color(p);
 gl_FragColor = vec4(c);

}