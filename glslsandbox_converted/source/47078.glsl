#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
 
 gl_FragColor = vec4(0.0);
 
 vec2 _uv = gl_FragCoord.xy;
 vec2 _mouse = mouse * resolution.xy;
 
 gl_FragColor += vec4( vec3( 5.0 / distance( _uv, _mouse ) ), 1.0 );
 gl_FragColor += vec4( vec3( 3.0 / distance( _uv, _mouse + vec2( cos(time), sin(time) ) * 20.0 ) ), 1.0 );
 gl_FragColor += vec4( vec3( 2.0 / distance( _uv, _mouse + vec2( cos(time * 2.0), sin(time * 2.0) ) * 40.0 ) ), 1.0 );
 gl_FragColor += vec4( vec3( 1.0 / distance( _uv, _mouse + vec2( cos(time * 3.0), sin(time * 3.0) ) * 60.0 ) ), 1.0 );
}