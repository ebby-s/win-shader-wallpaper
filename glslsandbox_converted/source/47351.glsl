#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;
void main(void){
 vec2 uv=surfacePosition;uv+=0.5;
 for(int i=0;i<128;i++){
  #define fi float(i)
  uv[int(mod(fi,2.))]+=sin(uv[int(mod(fi+1.,2.))]+(time*(mod(fi/2.,2.)==1.?1.:-1.))+fi)*.8;
 }
 gl_FragColor=vec4(fract(uv),(fract(uv.x/4.)+fract(uv.y/2.))/2.,1);
}