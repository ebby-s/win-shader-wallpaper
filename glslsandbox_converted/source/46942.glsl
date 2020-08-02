#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{
 vec2 pos = gl_FragCoord.xy;
 vec3 color = vec3(0, 0, 0);
 
 float speed = 1.0;
 
 float wave = (sin(time * speed) + 1.0) / 2.0 + (sin((pos.x / 20.0) + time * speed) + 1.0) / ((4.0 - ((sin(time) + 1.0) / 2.0 * 1.0)));
 if (pos.y < resolution.y * wave / 6.0 + resolution.y / 2.0 - 60.0) {
  color = vec3(0.1, 0.1, 0.4);
 }
 gl_FragColor = vec4(color, 1.0);
}