#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

//Shitty fireworks by czpal

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float tb = 2.0;



vec4 getFirework(float t)
{
 float tmp = mod(t,tb);
 float x = (cos(floor(t/tb)*3.234)+1.5)/3.0;
 return vec4(x, (log(tmp*6.0)/tb)*0.5, tmp, floor(t/tb));
}

vec3 getColor(float tmp)
{
 return vec3(cos(tmp), sin(tmp), cos(tmp*tmp));
}



void main( void ) 
{
 vec2 position = ( gl_FragCoord.xy / resolution.xy );
 
 
 
 vec4 firework = getFirework(time);
 
 vec3 value = getColor(firework.w);
 if(firework.z<tb*0.6)
  value *= 0.001/distance(position, firework.xy);
 else
 {
  vec2 tmp1 = abs(abs(position - firework.xy)+(tb*0.6-firework.z)*0.2);
  float tmp2 = atan(tmp1.y, tmp1.x);
  
  value *= (0.01/length(tmp1)) * sin((firework.z-tb*0.6)*3.0);
  value *= (sin(tmp2*firework.z*20.0)+1.0)*0.5;
 }
  
 
 gl_FragColor = vec4(value,1);

}