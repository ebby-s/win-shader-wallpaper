#ifdef GL_ES
precision mediump float;
#endif

//parellel sort networks generated using the bose-nelson algorithm
//sphinx

#define SPEED 32.
#define COUNT 32 

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void generate(out float l[COUNT]);
void sort(inout float l[COUNT]);
void swap(inout float a, inout float b);

float hash(in float x);
vec3 hsv(in float h, in float s, in float v);


void main( void ) 
{
 #if COUNT == 8 || COUNT == 16 || COUNT == 24 || COUNT == 32
 vec2 uv     = gl_FragCoord.xy / resolution.xy;
 vec2 panel     = floor(uv * vec2(1., 2.));
 vec2 panel_uv    = fract(uv * vec2(1., 2.));
 vec2 panel_grid    = floor(panel_uv * vec2(COUNT, 1.));
 vec3 result    = vec3(0., 0., 0.); 
 
 bool bottom     = panel.y == 0.;
 
 
 float list[COUNT]; 

 generate(list); 
 
 if(bottom)
 {
  sort(list);
 }
 
 for(int i = 0; i < COUNT; i++)
 {    
  if(float(i) == panel_grid.x)
  {
   float shade = abs(panel_uv.y/list[i])*.75+.25;
   if(bottom)
   {
    result += float(list[i] > panel_uv.y) * hsv(list[i] * .6, 1., 1.) * shade;
   }
   else
   {
    result += float(list[i] > panel_uv.y) * hsv(list[i] * .6, 1., 1.) * shade;
   }
  }
 } 

  
 gl_FragColor.xyz   = result;
 gl_FragColor.w    = 1.;
 #else 
 gl_FragColor    = vec4(0., 0., 0., 0.);
 #endif
}


vec3 hsv(in float h, in float s, in float v)
{
 return mix(vec3(1.,1.,1.), clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}


float hash(in float x)
{
 float k = x * 65537.618034;    
 return fract(fract(k * x) * k);
}


void generate(out float l[COUNT])
{
 float s = SPEED;
 float t = ceil(mod(time * s, 65536.))/65537.;
 float n = t;
 for(int i = 0; i < COUNT; i++)
 {
  l[i]  = hash(n + t * .18);
  n  = l[i];
 }
}


void sort(inout float l[COUNT])
{
 #if COUNT == 8
 swap(l[0], l[1]);
 swap(l[2], l[3]);
 swap(l[0], l[2]);
 swap(l[1], l[3]);
 swap(l[1], l[2]);
 swap(l[4], l[5]);
 swap(l[6], l[7]);
 swap(l[4], l[6]);
 swap(l[5], l[7]);
 swap(l[5], l[6]);
 swap(l[0], l[4]);
 swap(l[1], l[5]);
 swap(l[1], l[4]);
 swap(l[2], l[6]);
 swap(l[3], l[7]);
 swap(l[3], l[6]);
 swap(l[2], l[4]);
 swap(l[3], l[5]);
 swap(l[3], l[4]);
 #endif
 
 #if COUNT == 16
 swap( l[0],  l[1]);
 swap( l[2],  l[3]);
 swap( l[0],  l[2]);
 swap( l[1],  l[3]);
 swap( l[1],  l[2]);
 swap( l[4],  l[5]);
 swap( l[6],  l[7]);
 swap( l[4],  l[6]);
 swap( l[5],  l[7]);
 swap( l[5],  l[6]);
 swap( l[0],  l[4]);
 swap( l[1],  l[5]);
 swap( l[1],  l[4]);
 swap( l[2],  l[6]);
 swap( l[3],  l[7]);
 swap( l[3],  l[6]);
 swap( l[2],  l[4]);
 swap( l[3],  l[5]);
 swap( l[3],  l[4]);
 swap( l[8],  l[9]);
 swap(l[10], l[11]);
 swap( l[8], l[10]);
 swap( l[9], l[11]);
 swap( l[9], l[10]);
 swap(l[12], l[13]);
 swap(l[14], l[15]);
 swap(l[12], l[14]);
 swap(l[13], l[15]);
 swap(l[13], l[14]);
 swap( l[8], l[12]);
 swap( l[9], l[13]);
 swap( l[9], l[12]);
 swap(l[10], l[14]);
 swap(l[11], l[15]);
 swap(l[11], l[14]);
 swap(l[10], l[12]);
 swap(l[11], l[13]);
 swap(l[11], l[12]);
 swap( l[0],  l[8]);
 swap( l[1],  l[9]);
 swap( l[1],  l[8]);
 swap( l[2], l[10]);
 swap( l[3], l[11]);
 swap( l[3], l[10]);
 swap( l[2],  l[8]);
 swap( l[3],  l[9]);
 swap( l[3],  l[8]);
 swap( l[4], l[12]);
 swap( l[5], l[13]);
 swap( l[5], l[12]);
 swap( l[6], l[14]);
 swap( l[7], l[15]);
 swap( l[7], l[14]);
 swap( l[6], l[12]);
 swap( l[7], l[13]);
 swap( l[7], l[12]);
 swap( l[4],  l[8]);
 swap( l[5],  l[9]);
 swap( l[5],  l[8]);
 swap( l[6], l[10]);
 swap( l[7], l[11]);
 swap( l[7], l[10]);
 swap( l[6],  l[8]);
 swap( l[7],  l[9]);
 swap( l[7],  l[8]);
 #endif
 
 #if COUNT == 24
 swap( l[1],  l[2]);
 swap( l[0],  l[2]);
 swap( l[0],  l[1]);
 swap( l[4],  l[5]);
 swap( l[3],  l[5]);
 swap( l[3],  l[4]);
 swap( l[0],  l[3]);
 swap( l[1],  l[4]);
 swap( l[2],  l[5]);
 swap( l[2],  l[4]);
 swap( l[1],  l[3]);
 swap( l[2],  l[3]);
 swap( l[7],  l[8]);
 swap( l[6],  l[8]);
 swap( l[6],  l[7]);
 swap(l[10], l[11]);
 swap( l[9], l[11]);
 swap( l[9], l[10]);
 swap( l[6],  l[9]);
 swap( l[7], l[10]);
 swap( l[8], l[11]);
 swap( l[8], l[10]);
 swap( l[7],  l[9]);
 swap( l[8],  l[9]);
 swap( l[0],  l[6]);
 swap( l[1],  l[7]);
 swap( l[2],  l[8]);
 swap( l[2],  l[7]);
 swap( l[1],  l[6]);
 swap( l[2],  l[6]);
 swap( l[3],  l[9]);
 swap( l[4], l[10]);
 swap( l[5], l[11]);
 swap( l[5], l[10]);
 swap( l[4],  l[9]);
 swap( l[5],  l[9]);
 swap( l[3],  l[6]);
 swap( l[4],  l[7]);
 swap( l[5],  l[8]);
 swap( l[5],  l[7]);
 swap( l[4],  l[6]);
 swap( l[5],  l[6]);
 swap(l[13], l[14]);
 swap(l[12], l[14]);
 swap(l[12], l[13]);
 swap(l[16], l[17]);
 swap(l[15], l[17]);
 swap(l[15], l[16]);
 swap(l[12], l[15]);
 swap(l[13], l[16]);
 swap(l[14], l[17]);
 swap(l[14], l[16]);
 swap(l[13], l[15]);
 swap(l[14], l[15]);
 swap(l[19], l[20]);
 swap(l[18], l[20]);
 swap(l[18], l[19]);
 swap(l[22], l[23]);
 swap(l[21], l[23]);
 swap(l[21], l[22]);
 swap(l[18], l[21]);
 swap(l[19], l[22]);
 swap(l[20], l[23]);
 swap(l[20], l[22]);
 swap(l[19], l[21]);
 swap(l[20], l[21]);
 swap(l[12], l[18]);
 swap(l[13], l[19]);
 swap(l[14], l[20]);
 swap(l[14], l[19]);
 swap(l[13], l[18]);
 swap(l[14], l[18]);
 swap(l[15], l[21]);
 swap(l[16], l[22]);
 swap(l[17], l[23]);
 swap(l[17], l[22]);
 swap(l[16], l[21]);
 swap(l[17], l[21]);
 swap(l[15], l[18]);
 swap(l[16], l[19]);
 swap(l[17], l[20]);
 swap(l[17], l[19]);
 swap(l[16], l[18]);
 swap(l[17], l[18]);
 swap( l[0], l[12]);
 swap( l[1], l[13]);
 swap( l[2], l[14]);
 swap( l[2], l[13]);
 swap( l[1], l[12]);
 swap( l[2], l[12]);
 swap( l[3], l[15]);
 swap( l[4], l[16]);
 swap( l[5], l[17]);
 swap( l[5], l[16]);
 swap( l[4], l[15]);
 swap( l[5], l[15]);
 swap( l[3], l[12]);
 swap( l[4], l[13]);
 swap( l[5], l[14]);
 swap( l[5], l[13]);
 swap( l[4], l[12]);
 swap( l[5], l[12]);
 swap( l[6], l[18]);
 swap( l[7], l[19]);
 swap( l[8], l[20]);
 swap( l[8], l[19]);
 swap( l[7], l[18]);
 swap( l[8], l[18]);
 swap( l[9], l[21]);
 swap(l[10], l[22]);
 swap(l[11], l[23]);
 swap(l[11], l[22]);
 swap(l[10], l[21]);
 swap(l[11], l[21]);
 swap( l[9], l[18]);
 swap(l[10], l[19]);
 swap(l[11], l[20]);
 swap(l[11], l[19]);
 swap(l[10], l[18]);
 swap(l[11], l[18]);
 swap( l[6], l[12]);
 swap( l[7], l[13]);
 swap( l[8], l[14]);
 swap( l[8], l[13]);
 swap( l[7], l[12]);
 swap( l[8], l[12]);
 swap( l[9], l[15]);
 swap(l[10], l[16]);
 swap(l[11], l[17]);
 swap(l[11], l[16]);
 swap(l[10], l[15]);
 swap(l[11], l[15]);
 swap( l[9], l[12]);
 swap(l[10], l[13]);
 swap(l[11], l[14]);
 swap(l[11], l[13]);
 swap(l[10], l[12]);
 swap(l[11], l[12]);
 #endif 
 
 #if COUNT == 32
 swap( l[0],  l[1]);
 swap( l[2],  l[3]);
 swap( l[0],  l[2]);
 swap( l[1],  l[3]);
 swap( l[1],  l[2]);
 swap( l[4],  l[5]);
 swap( l[6],  l[7]);
 swap( l[4],  l[6]);
 swap( l[5],  l[7]);
 swap( l[5],  l[6]);
 swap( l[0],  l[4]);
 swap( l[1],  l[5]);
 swap( l[1],  l[4]);
 swap( l[2],  l[6]);
 swap( l[3],  l[7]);
 swap( l[3],  l[6]);
 swap( l[2],  l[4]);
 swap( l[3],  l[5]);
 swap( l[3],  l[4]);
 swap( l[8],  l[9]);
 swap(l[10], l[11]);
 swap( l[8], l[10]);
 swap( l[9], l[11]);
 swap( l[9], l[10]);
 swap(l[12], l[13]);
 swap(l[14], l[15]);
 swap(l[12], l[14]);
 swap(l[13], l[15]);
 swap(l[13], l[14]);
 swap( l[8], l[12]);
 swap( l[9], l[13]);
 swap( l[9], l[12]);
 swap(l[10], l[14]);
 swap(l[11], l[15]);
 swap(l[11], l[14]);
 swap(l[10], l[12]);
 swap(l[11], l[13]);
 swap(l[11], l[12]);
 swap( l[0],  l[8]);
 swap( l[1],  l[9]);
 swap( l[1],  l[8]);
 swap( l[2], l[10]);
 swap( l[3], l[11]);
 swap( l[3], l[10]);
 swap( l[2],  l[8]);
 swap( l[3],  l[9]);
 swap( l[3],  l[8]);
 swap( l[4], l[12]);
 swap( l[5], l[13]);
 swap( l[5], l[12]);
 swap( l[6], l[14]);
 swap( l[7], l[15]);
 swap( l[7], l[14]);
 swap( l[6], l[12]);
 swap( l[7], l[13]);
 swap( l[7], l[12]);
 swap( l[4],  l[8]);
 swap( l[5],  l[9]);
 swap( l[5],  l[8]);
 swap( l[6], l[10]);
 swap( l[7], l[11]);
 swap( l[7], l[10]);
 swap( l[6],  l[8]);
 swap( l[7],  l[9]);
 swap( l[7],  l[8]);
 swap(l[16], l[17]);
 swap(l[18], l[19]);
 swap(l[16], l[18]);
 swap(l[17], l[19]);
 swap(l[17], l[18]);
 swap(l[20], l[21]);
 swap(l[22], l[23]);
 swap(l[20], l[22]);
 swap(l[21], l[23]);
 swap(l[21], l[22]);
 swap(l[16], l[20]);
 swap(l[17], l[21]);
 swap(l[17], l[20]);
 swap(l[18], l[22]);
 swap(l[19], l[23]);
 swap(l[19], l[22]);
 swap(l[18], l[20]);
 swap(l[19], l[21]);
 swap(l[19], l[20]);
 swap(l[24], l[25]);
 swap(l[26], l[27]);
 swap(l[24], l[26]);
 swap(l[25], l[27]);
 swap(l[25], l[26]);
 swap(l[28], l[29]);
 swap(l[30], l[31]);
 swap(l[28], l[30]);
 swap(l[29], l[31]);
 swap(l[29], l[30]);
 swap(l[24], l[28]);
 swap(l[25], l[29]);
 swap(l[25], l[28]);
 swap(l[26], l[30]);
 swap(l[27], l[31]);
 swap(l[27], l[30]);
 swap(l[26], l[28]);
 swap(l[27], l[29]);
 swap(l[27], l[28]);
 swap(l[16], l[24]);
 swap(l[17], l[25]);
 swap(l[17], l[24]);
 swap(l[18], l[26]);
 swap(l[19], l[27]);
 swap(l[19], l[26]);
 swap(l[18], l[24]);
 swap(l[19], l[25]);
 swap(l[19], l[24]);
 swap(l[20], l[28]);
 swap(l[21], l[29]);
 swap(l[21], l[28]);
 swap(l[22], l[30]);
 swap(l[23], l[31]);
 swap(l[23], l[30]);
 swap(l[22], l[28]);
 swap(l[23], l[29]);
 swap(l[23], l[28]);
 swap(l[20], l[24]);
 swap(l[21], l[25]);
 swap(l[21], l[24]);
 swap(l[22], l[26]);
 swap(l[23], l[27]);
 swap(l[23], l[26]);
 swap(l[22], l[24]);
 swap(l[23], l[25]);
 swap(l[23], l[24]);
 swap( l[0], l[16]);
 swap( l[1], l[17]);
 swap( l[1], l[16]);
 swap( l[2], l[18]);
 swap( l[3], l[19]);
 swap( l[3], l[18]);
 swap( l[2], l[16]);
 swap( l[3], l[17]);
 swap( l[3], l[16]);
 swap( l[4], l[20]);
 swap( l[5], l[21]);
 swap( l[5], l[20]);
 swap( l[6], l[22]);
 swap( l[7], l[23]);
 swap( l[7], l[22]);
 swap( l[6], l[20]);
 swap( l[7], l[21]);
 swap( l[7], l[20]);
 swap( l[4], l[16]);
 swap( l[5], l[17]);
 swap( l[5], l[16]);
 swap( l[6], l[18]);
 swap( l[7], l[19]);
 swap( l[7], l[18]);
 swap( l[6], l[16]);
 swap( l[7], l[17]);
 swap( l[7], l[16]);
 swap( l[8], l[24]);
 swap( l[9], l[25]);
 swap( l[9], l[24]);
 swap(l[10], l[26]);
 swap(l[11], l[27]);
 swap(l[11], l[26]);
 swap(l[10], l[24]);
 swap(l[11], l[25]);
 swap(l[11], l[24]);
 swap(l[12], l[28]);
 swap(l[13], l[29]);
 swap(l[13], l[28]);
 swap(l[14], l[30]);
 swap(l[15], l[31]);
 swap(l[15], l[30]);
 swap(l[14], l[28]);
 swap(l[15], l[29]);
 swap(l[15], l[28]);
 swap(l[12], l[24]);
 swap(l[13], l[25]);
 swap(l[13], l[24]);
 swap(l[14], l[26]);
 swap(l[15], l[27]);
 swap(l[15], l[26]);
 swap(l[14], l[24]);
 swap(l[15], l[25]);
 swap(l[15], l[24]);
 swap( l[8], l[16]);
 swap( l[9], l[17]);
 swap( l[9], l[16]);
 swap(l[10], l[18]);
 swap(l[11], l[19]);
 swap(l[11], l[18]);
 swap(l[10], l[16]);
 swap(l[11], l[17]);
 swap(l[11], l[16]);
 swap(l[12], l[20]);
 swap(l[13], l[21]);
 swap(l[13], l[20]);
 swap(l[14], l[22]);
 swap(l[15], l[23]);
 swap(l[15], l[22]);
 swap(l[14], l[20]);
 swap(l[15], l[21]);
 swap(l[15], l[20]);
 swap(l[12], l[16]);
 swap(l[13], l[17]);
 swap(l[13], l[16]);
 swap(l[14], l[18]);
 swap(l[15], l[19]);
 swap(l[15], l[18]);
 swap(l[14], l[16]);
 swap(l[15], l[17]);
 swap(l[15], l[16]);
 #endif
}


void swap(inout float a, inout float b)
{
 float c = min(a, b);
  b  = max(a, b);
 a  = c;
}

