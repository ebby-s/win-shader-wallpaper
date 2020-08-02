#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


//ramsey's theorem for pairs
//https://www.quantamagazine.org/mathematicians-bridge-finite-infinite-divide-20160524/ <- for playing with this 


#define ROWS   1 
#define COLUMNS  64
#define PRINT  true

//font drawing stuff
float extract_bit(float n, float e);
float sprite(float n, vec2 p);   
float digit(float n, vec2 p);
float print(float n, vec2 position);
float center_print(float n, vec2 position);


void main( void ) {

 vec2 fc   = gl_FragCoord.xy;
 vec2 extent  = resolution.xy;  
 vec2 border  = vec2(.125, 0.);
 vec2 uv   = fc.xy/extent.xy - border;
 float columns  = float(COLUMNS);
 float rows  = float(ROWS);
 
 vec2 domain  = vec2(columns, rows);
 
 vec2 field   = floor((uv - border) * domain);
 
 
 
 //ramseys theorem for pairs
 bool comparison  = false;
 
 
 float i   = floor(fract(time * .125) * columns * 2. - columns * .5);
 
 
 bool in_mod  = uv.x > .125 && uv.x < .625;
 bool center_line  = abs(uv.y-.5) * 2. < 1./columns;
 bool hilight  = center_line && i == field.x;
 
 
 vec2 print_uv  = mod(fc.xy, extent/domain) - (extent/domain) * .5;
 float n   = field.y == 0. ? field.x : field.y;
 float print  = center_print(abs(n), print_uv) * float(PRINT);
 print    *= .25 + float(in_mod);  
 
 
 
 vec3 color  = vec3(0., .5, .125);
 
 vec4 result  = vec4(0., 0., 0., 1.);
 
 
 result.xyz   = float(comparison) * color;
 result.xy  += vec2(hilight && !in_mod,hilight && in_mod)*.45;
 result   += print * .95;
 result    += field.x/domain.x * .5;
 gl_FragColor   = result;
}//sphinx


float extract_bit(float n, float e)
{
 return fract(n/exp2(e+1.));
}


float sprite(float n, vec2 p)
{
 p  = floor(p);
 float bounds  = float(all(bvec2(p.x < 3., p.y < 5.)) && all(bvec2(p.x >= 0., p.y >= 0.)));
 return extract_bit(n, (2. - p.x) + 3. * p.y) * bounds;
}

    
float digit(float n, vec2 p)
{
 return (n == 1.) ? sprite( 9362., p) 
   : n == 2. ? sprite(29671., p) 
   : n == 3. ? sprite(29391., p) 
   : n == 4. ? sprite(23497., p) 
   : n == 5. ? sprite(31183., p) 
   : n == 6. ? sprite(31215., p) 
   : n == 7. ? sprite(29257., p) 
   : n == 8. ? sprite(31727., p) 
   : n == 9. ? sprite(31695., p) 
   :      sprite(31599., p);
}

 

float print(float n, vec2 position)
{ 
 float offset = 4.;
 float result = 0.;
 
 for(int i = 0; i < 8; i++)
 {
  float place = pow(10., float(i));
  
  if(n >= place || i == 0)
  {
   position.x += 4.;
   result   += digit(floor(mod(floor(n/place)+.5, 10.)), position);  
  }
  else
  {
   break;
  }
  
 }
 return floor(result+.5);
}
   


float center_print(float n, vec2 position)
{
 position.y  += 2.;
 float badlog  = floor(log2(max(n, 1.))/log(5.))+2.;
 position.x  -= n == 0. ? 2. : badlog;
 return print(n, position);
}