#ifdef GL_ES
precision lowp float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define DERIV_DIF 0.01

struct surface_data
{
 float depth;
 vec3 normal; 
};

float nsin(float x) { return (sin(x) + 1.) / 2.; }
float ncos(float x) { return (cos(x) + 1.) / 2.; }
 
float getDepth(vec2 p)
{
 p.x += sin(p.y*12. + p.x + time*2.)*0.01;
 
 p.y += cos(p.x + p.y + time) * 0.1;
 
 float l = length(p);
 float val = sin(l * 20. + time) + cos(l * 17. + time*2.) + sin(p.x*p.y + time);

 return val;
 //p *= 6.;
 //float a0 = sin(p.x * p.y/2. + cos(p.x * p.y - time));
 //float a1 = sin(cos(p.x/2.) + sin(p.y));
 
 //return 0.1*abs(a0 - a1);
}

surface_data getSurface(vec2 p){
 float depth = getDepth(p);
 
 return surface_data(
  depth, 
  normalize(cross(
   vec3(DERIV_DIF, 0, getDepth(p + vec2(DERIV_DIF, 0)) - depth), 
   vec3(0, DERIV_DIF, getDepth(p + vec2(0, DERIV_DIF)) - depth)
  ))
 );
}

vec3 getColorAt(vec2 p)
{
 vec3 color = vec3(0.9, 0.6, 0.2);
 
 surface_data surface = getSurface(p);
 vec3 light_dir = normalize(vec3(1,1,-1));
 
 vec3 light_pos = vec3(p + vec2(cos(time), sin(time)), 0);
 
 //vec3 light_pos = vec3((mouse-.5), 1.);
 //light_pos.x *= resolution.x / resolution.y;
 
 color += vec3(1, 1, 1) * abs(dot(reflect(light_dir, surface.normal), light_pos));
 color += vec3(1, 1, 1) * dot(light_dir, surface.normal);
 //color += vec3(.2, .2, 0.2) * surface.depth;
 //color += vec3(1, 0, 0) * surface.dx;
 //color += vec3(0, 0, 1) * surface.depth;
 
 return color;
}

void main( void ) {

 vec2 pos = (gl_FragCoord.xy / resolution)-.5;
 pos.x *= resolution.x / resolution.y;
 
 gl_FragColor = vec4(getColorAt(pos), 1);

}