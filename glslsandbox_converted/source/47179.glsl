#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec3 bgColor = vec3(1.0,0.59,0.4);
void main( void ) {
 float maxRadius = max(resolution.x,resolution.y)/4.;
 
 vec3 color = bgColor;
 color *= 
  distance(gl_FragCoord.xy,resolution.xy/2.)<=(maxRadius*mod(time,1.))
  ? (mod(time,1.))
  : 1.;
 gl_FragColor = vec4(color,1.);

}