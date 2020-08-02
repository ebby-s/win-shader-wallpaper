#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 uv = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

 float a=sin((uv.x+uv.y)*time)+cos((uv.x+uv.y)*time);
 float b=99.0*time;

 gl_FragColor = vec4(a,b,inversesqrt(a), 1.0 );

}