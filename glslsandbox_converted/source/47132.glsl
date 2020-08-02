#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.x ) ;
 position = position * 2. - 1.;
 position.y += 0.5;
 
 vec2 center = vec2(0., 0.);

 vec4 color = vec4(1., 0., 0., 1.);
 
 if (length(position - center) - 0.5 > 0.)
  color = vec4(0.0, 0.0, 0.0, 1.0);
 else 
  color = vec4(0., 0., 1., 1.);
 
 gl_FragColor = color;
}