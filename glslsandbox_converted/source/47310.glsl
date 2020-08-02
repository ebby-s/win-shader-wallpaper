#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
void main(void){
 //vec2 uv=gl_FragCoord.xy/resolution.xy;uv=uv*2.-1.;uv.x*=resolution.x/resolution.y;uv+=.5;
 vec2 uv=(gl_FragCoord.xy-.5*resolution.xy)/resolution.y;uv+=.5;
 gl_FragColor=vec4(fract(uv),(uv.x>=0.&&uv.x<1.)&&(uv.y>=0.&&uv.y<1.),1.);
}