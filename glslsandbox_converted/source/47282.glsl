#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

  vec2 xy = gl_FragCoord.xy / resolution;
  gl_FragColor = vec4(abs(sin(time / 5.0) / 2.0 + xy.x),
        abs(sin(time) / 2.0 + xy.y),
        abs(sin(time * 5.0) / 2.0 + 0.3), 1.0);

}