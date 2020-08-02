#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float i;

void main( void ) {
 i++;
 gl_FragColor = vec4(sin(time) * sin(i));

}