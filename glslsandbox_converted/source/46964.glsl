#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}
void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
 
 vec2 _resolution = resolution * rotate2d( gl_FragCoord.x * 0.01 + time * 0.1 );
 float _dist = distance( gl_FragCoord.xy, mouse * _resolution.xy );
 float _opacity = sin( _dist * 3.1416 / 20.0 - time * 10.0 ) * 0.5 + 0.5;
 _opacity = floor( _opacity * 4.0 ) / 4.0;
 gl_FragColor = vec4( vec3( 0.1, 0.64, 0.92 ) * _opacity, 1.0 );
}