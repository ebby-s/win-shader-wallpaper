#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

//Shitty fireworks by czpal

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


const float tb = 2.0;
const int nr_of_fireworks = 3;



vec4 getFirework(float t, float seed)
{
 t+=seed*100.0;
 float tmp = mod(t,tb);
 float x = (cos(floor(t/tb)*3.234)+1.5)/3.0;
 return vec4(x, (log(tmp*10.0)/tb)*0.5, tmp+seed, floor(t/tb));
}

vec3 getColor(float tmp)
{
 return vec3((1.+cos(tmp))*.5, (1.+sin(tmp))*.5, (1.+cos(tmp*tmp))*.5);
}

vec3 calculateFireworks(vec2 position, float tab[nr_of_fireworks])
{
 vec3 color;
 
 
 for(int i = 0;i<nr_of_fireworks;i++)
 {
  vec4 firework = getFirework(time, tab[i]);
  
  vec3 value = getColor(firework.w);
  if(firework.z<tb*0.6)
   value *= 0.005/distance(position, firework.xy);
  else
  {
   vec2 tmp1 = (firework.xy-position);
   #define R2(T) mat2(cos(T),sin(T),-sin(T),cos(T))
   float accum = (firework.z-tb*0.6);
   float produ = 1.;
   for(float i = 0.; i <= 5.; i += 1.01){
    produ *= accum;
    tmp1 += vec2(0.1,0.1)*sign(tmp1)*(-0.1-0.1*i)*produ;
    tmp1 *= R2(time/max(12.-i, 1.0));
    
   }

   value *= (0.01/length(tmp1)) * sin((firework.z-tb*0.6)*3.0);

   value /= (6.+10.*accum);
   value += dot(value,value)*(0.1+value);
  }
  color = mix(color, value, 0.5);
 } 
  
 return color;
}



void main( void ) 
{
 vec2 position = ( gl_FragCoord.xy / resolution.xy );
 
 float tab[nr_of_fireworks];
 tab[0] = 0.0;
 tab[1] = 0.6;
 tab[2] = 0.8;

 
 
 
 vec3 value = calculateFireworks(position, tab);
 
 gl_FragColor = vec4(value,1);

}