#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float length_v2( vec2 vec )
{
 return sqrt ( vec.x * vec.x + vec.y * vec.y );
}

float sum_v4( vec4 v )
{
 return v.x + v.y + v.z + v.w;
}

void main( void ) {

 vec2 center = ( mouse.xy * resolution.xy );
 vec2 diff = gl_FragCoord.xy - center;
 float light_radius = 250.0;
 float dist = length_v2( diff );
 float intensity = 0.5 - dist / light_radius;
 vec4 color = vec4 ( intensity, intensity, intensity, 1.0 );
 
 vec4 background_color = vec4 ( fract( gl_FragCoord.x / sin( gl_FragCoord.y )), 0.0, 0.0, 1.0 );
 
 if ( sum_v4( background_color ) > 1.5 ){
  gl_FragColor = mix (color, background_color, 0.4 );
 }else {
  gl_FragColor = vec4( 0.0, 0.0, 0.0, 1.0 );
 }
 

}