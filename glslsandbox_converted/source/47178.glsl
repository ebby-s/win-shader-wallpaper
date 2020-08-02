#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 resolution;

void main( void ) {

 vec2 p = gl_FragCoord.xy;
 p *= 0.15;
 float s = atan(p.x*0.21+time*5.0)*sin(p.x*0.2+time*3.2);
 float t = atan(p.x*0.2-time*3.2)*sin(p.y*0.11-s)*sin(p.x*0.2-time*3.2)*sin(p.y*0.11-s);
 float f = (s*(t-s))-sin(time);
 
 vec2 uv = gl_FragCoord.xy / 0.0046; //divide by different amounts
 uv = uv - t;
 gl_FragColor = vec4(f-sin(time),t,s,1)/8.0/sin(uv.y);
}