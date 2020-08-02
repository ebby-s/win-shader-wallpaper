#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 resolution;
#define r resolution
#define t time
void main( void ) {
 vec2 p=gl_FragCoord.xy/r-0.5;
 p.x /= .01*length(p.y*200.0 );
 
 p.x +=r.x/r.y*0.5;
  
 vec3 col=vec3(0.3,0.3,0.3);
 
 float fy=fract(p.y*8.0);
 col+=smoothstep(0.495, 0.45, abs(fy-0.5));
 float fx=fract(p.x*4.0);
 col*=smoothstep(0.495, 0.41, abs(fx-0.5));
 gl_FragColor=vec4(col, 1.0);
}