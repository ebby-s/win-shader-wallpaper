#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 p = 2.0*( gl_FragCoord.xy / resolution.xy )-1.0;
 p.x *= resolution.x/resolution.y; 
 vec3 col = vec3(0);
 
 
 float c = .5+.5*sin(p.y*0.1+(time/5.+clamp(1.0/(30.0*abs(length(p.xy)-0.8)), 0.0, 1.0)*2.0)/2.);
 gl_FragColor = vec4(c,(c>0.0)?c*c:0.0, 0.3, 1.0); 
}