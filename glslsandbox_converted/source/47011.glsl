#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float f(float a, float b) {
    return sin(10.3 * length((gl_FragCoord.xy / resolution.xy - vec2(.5)) * 2.0 + vec2(cos(a), sin(b))));
}

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
 vec2 uv = gl_FragCoord.xy / resolution.xy;

 float color = 0.0;
 //color += sin( uv.x * cos( time / 15.0 ) * 20.0 ) * cos( uv.x * cos( time / 15.0 ) * 50.0 );
 //color += sin( uv.y * sin( time / 10.0 ) * 40.0 ) + cos( uv.x * sin( time / 25.0 ) * 40.0 );
 //color += sin( uv.x * sin( time / 5.0 ) * 10.0 ) + sin( uv.y * sin( time / 35.0 ) * 80.0 );
 //color *= sin( time / 10.0 ) * 0.5;
 //color = sin(50.3 * uv.x * length(color)) + cos(uv.y);
 
 color += sin(0.1 * length((uv + vec2(-0.5)) * time));
 color -= f(time, time) * f(f(time * 0.2, uv.x), uv.y);
 //color += sin(uv.x * 5.0) + cos(uv.y * 5.0) * sin( time / 10.0 ) * 0.5;

 //gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
 gl_FragColor = vec4( vec3(color), 1.0 );

}