#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{
 float t = sin(time);
 float c = smoothstep(0, t, 0.8);

 gl_FragColor = vec4( c, c, c, 1.0 );

}