#ifdef GL_ES
precision mediump float;
#endif
#extension GL_OES_standard_derivatives : enable
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
void main(void){
 vec2 p=gl_FragCoord.xy,r=resolution;
 vec2 uv=vec2(
  r.y<r.x?(p.x/r.y)-(((r.x/r.y)-1.)/2.):p.x/r.x
  ,
  r.y<r.x?p.y/r.y:(p.y/r.x)-(((r.y/r.x)-1.)/2.)
 );
 gl_FragColor=vec4(fract(uv),(uv.x>=0.&&uv.x<1.)&&(uv.y>=0.&&uv.y<1.),1.);
}