#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
float col;


void main( void ) {

 vec2 pos = gl_FragCoord.xy;
 float d = dot(pos, vec2(sin(pos.x + time), sqrt(pos.y / time)));
 col = acos(d);
 gl_FragColor = vec4(sin(col), cos(col), tan(col), 1.0);
}