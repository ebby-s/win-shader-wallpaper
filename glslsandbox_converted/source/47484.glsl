#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
 
 
 const float cols = 16.;
 const float rows = 9.;
 
 vec2 position = gl_FragCoord.xy / resolution.xy;
 
 vec2 pos = position * vec2(cols, rows);
 vec2 cell = vec2(1) + pos - fract(pos);
 
 vec2 cell_pos = pos + .5 - cell;
 
 float color = 0.0;
 
 float F1 = 1. / cell.x - 1. / cell.y;
 float F2 = 1. / cell.y - 1. / cell.x;
 float F = mix(F1 + F2, F1 * F2, mouse.x);
 color = 1.5*(.5+.5*sin( time * F*10. ));
 
 color -= length(cell_pos)*0.125;
 
 gl_FragColor = vec4( vec3( color, color * 0.5, sin( 6.2*color + time / 3.0 ) * 0.75 ), 1.0 );
 

}