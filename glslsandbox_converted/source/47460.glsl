precision highp float;

//arithmetic encoder / decoder / h4x (note no time input or framebuffer, see parent for encoder decoder)

//TL:DR -> list of stuff on the left gets encoded into a line (the vertical black line) on probability space (the mess in the middle) and then decoded out onto the right side in the same order
//the magic is that the space has every possible order crammed in proportional to the inputs, and the line picks the spot that matches the order

//left side  - input series of symbols
//center     - probability space of all potential series with matching symbol ratios
//right side - series decoded from probability set and encoded phase

//the space is preserved as a fractal, which is handy
//every pixel could be running it's own set, if you were into that for whatever reason

//it still could optimized more, and less iterative (http://glslsandbox.com/e#27191.0) maybe..?


uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

#define SYMBOLS  2
#define ELEMENTS 8

//#define POLAR

#define MIN_RESOLUTION min(resolution.x, resolution.y)

#define LINE_WIDTH MIN_RESOLUTION/16./MIN_RESOLUTION

//#define DEBUG_SPACE
#ifdef DEBUG_SPACE
vec2 g_debug = vec2(0.);
#endif


float encode(in float probability[SYMBOLS], in float set[ELEMENTS]);
void decode(in float phase, in float probability[SYMBOLS], out float set[ELEMENTS]);
void count(inout float set[ELEMENTS], inout float probability[SYMBOLS]);
void derive(inout float probability[SYMBOLS]);
void zero(out float set[ELEMENTS]);
float sum(in float probability[SYMBOLS]);
vec3 symbol_color(float i);
vec3 symbol_h4x_color(float i);
vec3 hsv(float h,float s,float v);
float  verify_set(vec2 uv, in float set[ELEMENTS], in float verification[ELEMENTS]);
vec3  display_set(vec2 uv, in float set[ELEMENTS]);
void assign_random_symbols(out float set[ELEMENTS]);
void assign_gpu_h4x(out float set[ELEMENTS]);

float hash(vec2 uv);


void main( void ) 
{
 //formatting
 vec2 uv    = gl_FragCoord.xy/resolution.xy;
 vec2 p    = uv;
 
 #ifdef POLAR
 p     = uv * 2. - 1.;
 p    *= resolution.xy/MIN_RESOLUTION;
 p    = vec2((atan(p.x, p.y)+(4.*atan(1.)))/(8.*atan(1.)), length(p));
 #endif
 
 #ifdef DEBUG_SPACE
 g_debug.y   = p.y;
 #endif
 
 //assign some random symbols to the series based on mouse position and a random hash
 float set[ELEMENTS];
 assign_gpu_h4x(set);
 
 float verification_set[ELEMENTS];
 assign_gpu_h4x(verification_set); 
 
 vec3 initial_set   = display_set(uv.yx, set);

 
 //encode the set into a phase within it's probabilities
 float probability[SYMBOLS];
 count(set, probability);
 derive(probability);
 
 
 float phase    = encode(probability, set);

 
 //wipe the set (no cheating!)
 zero(set);
 
 
 decode(phase, probability, set);
 vec3 decoded_set   = display_set(uv.yx, set);
 
 float phase_line  = float(abs(p.x-phase)<.0025);
 #ifdef POLAR
 phase_line   = float(abs(p.x-phase)<.0025/length(p*4.));
 #endif
 
 float error_mask   = clamp(verify_set(p.yx, set, verification_set)+.5, 0., 1.);

 //decode the entire space for visualization (not a particular set, but all sets with the matching symbol probabilities)
 phase    = p.x;
 decode(phase, probability, set);
 
 vec3 probability_set   = display_set(p.yx, set);

 probability_set   *= error_mask;
 
 //display the results
 vec4 result   = vec4(0.);
 float scaled_uv   = uv.x * 64.;
 float column   = floor(scaled_uv);
 float display_initial_set = float(column < 1.);
 float display_decoded_set = float(column > 62.);
 float display_probability_set = float(scaled_uv < 63. - LINE_WIDTH && scaled_uv > 1. + LINE_WIDTH);
 
 initial_set   *= display_initial_set;
 decoded_set   *= display_decoded_set;
 probability_set   *= display_probability_set;
 
 result.xyz   = initial_set + decoded_set + probability_set;
 result.xyz   -= phase_line * float(length(probability_set) > 0.);
 

 result.w    = 1.;
 
 gl_FragColor    = result;
 
 #ifdef DEBUG_SPACE
 g_debug.y   = fract(p.y*float(ELEMENTS))*float(p.y*float(ELEMENTS)<float(ELEMENTS));
 gl_FragColor   = vec4(g_debug.xy, 0., 1.);
 #endif
}//sphinx


float encode(in float probability[SYMBOLS], in float set[ELEMENTS])
{
 float period  = 0.;
 float phase = 0.;

 float interval[SYMBOLS];
 for(int i = 0; i < SYMBOLS; i++)
 {
  interval[i] = probability[i];
 }
 
 for(int i = 0; i < ELEMENTS; i++)
 {
  for(int j = 0; j < SYMBOLS; j++)
  {
   if(set[i] == float(j))
   {
    period = probability[j];
    break;
   }
   
   phase +=  interval[j];
  }
  
  for(int j = 0; j < ELEMENTS; j++)
  {
   interval[j] *= clamp(period, 0., 1.);
  }
 }
 
 return phase;
}


void decode(in float phase, in float probability[SYMBOLS], out float set[ELEMENTS])
{
 float period  = 1.;
 for(int i = 0; i < ELEMENTS; i++)
 {
  float theta = phase;

  for(int j = SYMBOLS-1; j >= 0; j--)
  {   
   bool match  = period > theta;
   set[i]   = match ? float(j)     : set[i];
   phase    = match ? abs(theta-period)/probability[j] : phase;     
   period   = period - probability[j];
  }
  
  period = phase+phase;
  
  #ifdef DEBUG_SPACE
  if(floor(g_debug.y*float(ELEMENTS))==float(i))
  {
   g_debug.x = 1.-period/2.;
  }
  #endif
 }
}


float sum(in float probability[SYMBOLS])
{
 float sum = 0.;
 for(int i = 0; i < SYMBOLS; i++)
 {
  sum += probability[i];
 }
 
 return sum;
}


void count(inout float series[ELEMENTS], inout float probability[SYMBOLS])
{
 for(int j = 0; j < SYMBOLS; j++)
 {
  probability[j] = 0.; 
 }
 
 for(int i = 0; i < ELEMENTS; i++)
 {
  for(int j = 0; j < SYMBOLS; j++)
  {
   probability[j] += float(series[i] == float(j));
  }
 }
}


void derive(inout float probability[SYMBOLS])
{ 
 float s = 1./sum(probability);
 for(int i = 0; i < SYMBOLS; i++)
 {
  probability[i] *= s;
 }
}


void zero(out float set[ELEMENTS])
{
 for(int i = 0; i < ELEMENTS; i++)
 {
  set[i] = 0.;
 }
}


vec3 display_set(vec2 uv, in float set[ELEMENTS])
{
 float index  = floor(uv.x * float(ELEMENTS));
 vec3 visualization = vec3(0.);
 for(int i = 0; i < ELEMENTS; i++)
 {
  if(float(i) == index)
  {
   visualization = symbol_h4x_color(set[i]);
  }
 }
 
 float grid = float(fract(uv.x * float(ELEMENTS)+LINE_WIDTH*.5)>LINE_WIDTH);
 return visualization * grid;
}


float verify_set(vec2 uv, in float set[ELEMENTS], in float verification[ELEMENTS])
{
 float index  = floor(uv.x * float(ELEMENTS));
 float error_mask = 1.;
 for(int i = 0; i < ELEMENTS; i++)
 {
  if(float(i) == index)
  {
   error_mask *= float(set[i] == verification[i]);
  }
 }

 return error_mask;
}


vec3 symbol_color(float i)
{
 return hsv(i/float(SYMBOLS)*.75, 1., 1.);  
}

vec3 symbol_h4x_color(float i)
{
 return vec3(1., 1., 1.) * i/float(SYMBOLS) ;
}



vec3 hsv(float h,float s,float v)
{
 return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}


float hash(vec2 uv)
{
 return clamp(fract(cos(uv.x+sin(uv.y))*12345.6789), pow(2., -16.), 1.-pow(2., -16.));
}


void assign_mouse_symbols(out float set[ELEMENTS])
{
 for(int i = 0; i < ELEMENTS; i++)
 {
  float symbol  = floor(hash(mouse+float(i)/float(SYMBOLS))*float(SYMBOLS));
  set[i]  = symbol;
 }
}

void assign_random_symbols(out float set[ELEMENTS])
{
 for(int i = 0; i < ELEMENTS; i++)
 {
  float symbol  = floor(hash(mouse+float(i)/float(ELEMENTS))*float(SYMBOLS));
  set[i]  = symbol;
 }
}

void assign_gpu_h4x(out float set[ELEMENTS])
{
 for(int i = 0; i < ELEMENTS; i++)
 {
  float symbol  = 2.; //floating point failure point!
  set[i]  = symbol;
 }
}