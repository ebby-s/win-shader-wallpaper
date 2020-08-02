#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 uv = ( gl_FragCoord.xy - (.5 * resolution) ) / resolution.y;
 
 vec2 st = vec2(atan(uv.x,uv.y), length(uv));
 uv = vec2(st.x/6.28+.1 - time/5. + st.y * 3.0,st.y);
 
 float x = uv.x*5.;
 float m = min(fract(x), fract(1.-x));
 float c = smoothstep(0.0,0.6,m*1.0 +.2 - uv.y);
 

 gl_FragColor = vec4( tan(c+st.y-time*1.)/2., tan(c+st.y-time*1.2)/2.+.5, tan(c+st.y-time*1.5)/2.+.5, 1. );

}