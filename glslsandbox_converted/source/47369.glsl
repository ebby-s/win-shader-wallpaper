#ifdef GL_ES
precision mediump float;
#endif

///Shadow thing. Saving for later

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const vec4 empty = vec4(0.0,0.0,0.0,0.0);
const vec4 shadow = vec4(0.0,0.0,0.0,1.0);
const vec4 test = vec4(1.0,1.0,1.0,1.0);
float u_r = 0.45;

void main(void)
{ 
 vec2 bounds = ((gl_FragCoord.xy / resolution.xy)-0.5)*2.0;
 float frame = (fract(time/10.0))*2.0;
 
 bounds*=2.0;

 
 if(frame<1.0) gl_FragColor = mix(shadow,test,smoothstep(0.0,1.0,(1.0-(length(max(abs(bounds),(1.0-u_r))-(1.0-u_r))-u_r)))*frame*0.6);
 else
 {
  frame-=1.0;
  float a = 0.6+(frame/8.0);
  gl_FragColor = mix(shadow,test,smoothstep(frame,1.0,(1.0-(length(max(abs(bounds),(1.0-u_r))-(1.0-u_r))-u_r)))*a);
 }

}