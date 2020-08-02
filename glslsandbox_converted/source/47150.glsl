#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

#define MAX_ITERATIONS 60

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 pos = ( gl_FragCoord.xy / resolution.xy );

 vec2 zPos = vec2(3.0, 2.0) * (pos - vec2(0.5));
 vec2 cPos = mouse;
 
 vec3 finalColor;
 
 int finalIteration;
 
 for(int iteration = 0; iteration < MAX_ITERATIONS; iteration++)
 {  
        finalIteration = iteration;

  vec2 temp = vec2((zPos.x * zPos.x - zPos.y * zPos.y) - cPos.x, (zPos.y * zPos.x + zPos.x * zPos.y) - cPos.y);
  
         if((temp.x * temp.x + temp.y * temp.y) > 4.0) break;
         
  zPos.x = temp.x;
         zPos.y = temp.y; 
 }
 
 if(finalIteration == MAX_ITERATIONS) finalColor = vec3(0.0);
 else finalColor = vec3(float(finalIteration)/100.0);
  
 gl_FragColor = vec4(finalColor*vec3(zPos, 1.0), 1.0);
}