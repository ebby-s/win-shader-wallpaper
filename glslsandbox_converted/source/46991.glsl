// nikitpad (c) 2018

#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{
 vec2 texcoord = ( gl_FragCoord.xy / resolution.xy );
 vec3 rainbow = vec3(sin(time), sin(time + 2.0), sin(time + 4.0));
 gl_FragColor = vec4(rainbow * texcoord.y * 2.0 + 0.5 + texcoord.x, 1.0);
}