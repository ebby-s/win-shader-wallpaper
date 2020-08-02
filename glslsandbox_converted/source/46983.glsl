#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
 vec2 c = resolution.xy / 2.;
 vec2 p = gl_FragCoord.xy - resolution.xy * .5;
 float t = mod(time,10.0);
 t *= c.x < length(p) ? 0. : pow((c.x - length(p))/length(c),1.5) * 5.;
 gl_FragColor = vec4( p.y*cos(t) < p.x*sin(t) ? 1 : 0 ) ;
}