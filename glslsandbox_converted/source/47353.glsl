#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( 2. * gl_FragCoord.xy - resolution.xy ) / resolution.y;

  
 float color = 0.0;
  
 vec2 uv = position;
 uv = fract(uv)-.5;
 color += (0.01 / length(uv));
 
 gl_FragColor = vec4( vec3(color), 1.0 );

}