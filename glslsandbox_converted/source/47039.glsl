#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 uv = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
        vec3 color1=vec3(1.0,1.0,0.0);
 vec3 color2=vec3(0.0,1.0,1.0);
 gl_FragColor = vec4( mix(color1,color2,uv.y), 1.0 );

}