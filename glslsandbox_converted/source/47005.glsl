#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PHI = sqrt(5.0) * 0.5 + 0.5;

void main( void ) {

 vec2 texcoord = gl_FragCoord.xy / resolution.xy;
      //texcoord = vec2(0.5);
 
 vec3 color = normalize(vec3(texcoord.x * 2.0, texcoord.y * 2.0, (1.0 - texcoord.x) * 2.0)+1.0)-0.5;
      color = sqrt(color);
      color = normalize(color);
      color = color * color;
      color = clamp(color, 0.0, 1.0);

 gl_FragColor = vec4(color, 1.0 );

}