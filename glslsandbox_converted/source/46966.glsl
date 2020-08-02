#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 texcoord = gl_FragCoord.xy / resolution.xy;
      //texcoord = vec2(0.5);
 
 vec3 color = normalize(vec3(texcoord.x * 2.0 - 1.0, texcoord.y * 2.0 - 1.0, (1.0 - texcoord.x) * 2.0 - 1.0) + 1.0)*2.0-1.0;

 gl_FragColor = vec4(normalize(color), 1.0 );

}