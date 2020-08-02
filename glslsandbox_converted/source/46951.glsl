#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
 vec2 uv = normalize( (gl_FragCoord.xy+vec2(-resolution.x*0.5,-resolution.y*0.5)));

 float ac = abs(atan(uv.x/uv.y))+time;
 vec3 col = vec3(ac,0,0);
 if( mod(ac*20.0,15.0) > 7.0 )
  col = vec3(1,1,0);

 gl_FragColor = vec4( col, 1.0 );

}