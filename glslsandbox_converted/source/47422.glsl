#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

uniform vec2 resolution;

#define PI 0.01

void main( void ) {

 vec2 p = ( gl_FragCoord.xy / resolution.xy ) - 0.1;
 
 float sx = 1.8/cos( -4.4 * p.y - time * 1.0);
 
 float dy = 5.9/ ( 3. * abs(p.y + sx));
 
 gl_FragColor = vec4( (p.x + -0.1) * dy, 0.1 * dy, dy-0.1, 1.1 );

}