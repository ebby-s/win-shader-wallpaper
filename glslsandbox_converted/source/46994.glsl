#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void) 
{
 vec2 texCoord = ( gl_FragCoord.xy / resolution.xy );
 /*if (texCoord.y > 0.3 && texCoord.y < 0.4 && texCoord.x > 0.3 && texCoord.x < 0.35)
  gl_FragColor = vec4(sin(time) + sin(texCoord.y), sin(time + 2.0) + sin(texCoord.y), sin(time + 4.0) + sin(texCoord.y), 1.0);*/
 gl_FragColor = vec4((ceil(cos(texCoord.y) * 50.0)) / 100.0, (ceil(sin(texCoord.x) * 50.0)) / 100.0, ceil(texCoord.y * 50.0) / 100.0, 1.0);
}