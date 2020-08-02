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
 gl_FragColor=vec4(fract(uv),0.0,1.0);
}