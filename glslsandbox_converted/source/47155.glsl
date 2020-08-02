#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}


void main( void ) {
 
 int i;
 vec2 position = ( gl_FragCoord.xy / resolution.xy * 4.0);
 
 position.xy -= vec2(2.0,2.0);

 float color = 0.0;

 for (int i = 0 ; i < 100; i++) {
  if (sdSphere(vec3(position.xy, float(i)), 1.0) < 0.0) {
   color = 1.0;
  }
 }
      
       

 gl_FragColor = vec4( vec3( color, color , color), 1.0 );

}