#ifdef GL_ES
precision mediump float;
#endif
//tweaked by psyreco

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = abs( gl_FragCoord.xy * 2.0 -  resolution) / min(resolution.x, resolution.y);
 vec3 destColor = vec3(.70, 0.0, .75 );
 float f = 0.25;
 
 for(float i = 0.5; i < 15.0; i++){
  
  float s = asin(sin(time/3.0 / i )) ;
  float c =(cos(time/7.0 / i ));
  f +=abs(0.037 / abs(length(5.0* position *f - vec2(c, s) ) -.74));
 }

 gl_FragColor = vec4(vec3(destColor * f) + vec3(destColor.yzx * f/2.0), 1.0);
}