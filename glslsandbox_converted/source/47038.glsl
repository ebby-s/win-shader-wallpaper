// nikitpad, 2018

#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void) 
{
 vec2 texCoord = (gl_FragCoord.xy / resolution.xy);
 if (texCoord.y > 0.0)
  gl_FragColor = vec4(1.0, 1.0, 0.0, 1.0);
 if (texCoord.y > 0.3)
  gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);
 if (texCoord.y > 0.7)
  gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
 
 
}