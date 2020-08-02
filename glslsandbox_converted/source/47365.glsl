#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {

 vec2 p = ( gl_FragCoord.xy / resolution.x );

 float scale = 65.0*(1.5+cos(time/13.0 + sin(p.x)+ sin(p.y)));
 
 vec3 hue = vec3(p.x,p.y,0.0);
 float color = 0.0;
 color = (sin(p.x*scale) + sin(p.y*scale) -1.7)*4.0;

 gl_FragColor = vec4( color * hue, 1.0 );

}