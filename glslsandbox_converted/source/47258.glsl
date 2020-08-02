#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy );

 vec3 color = vec3(0);
 
 for(int i = 1; i < 10; i++) {
   //  float pos = mod(float(time * i), 1.);
 // color += abs(position.x - pos);
 }

 gl_FragColor = vec4( color, 1.0 );

}