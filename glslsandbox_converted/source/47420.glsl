#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float wave(vec2 uv, vec2 emitter, float speed, float phase){
 float dst = distance(uv, emitter);
 return pow((0.5 + 0.5 * sin(dst * phase - time * speed)), 2.0);
}

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy );

 
 float w = wave(position, vec2(0.5, 0.5), 2.0, 50.0);
// w += wave(position, vec2(0.6, 0.11), 2.0, 20.0);
// w += wave(position, vec2(0.9, 0.6), 10.0, 90.0);
// w += wave(position, vec2(0.1, 0.84), 10.0, 150.0);
// w += wave(position, vec2(0.32, 0.81), 10.0, 150.0);
// w += wave(position, vec2(0.16, 0.211), 10.0, 150.0);
// w += wave(position, vec2(0.39, 0.46), 10.0, 150.0);
// w += wave(position, vec2(0.51, 0.484), 10.0, 150.0);
// w += wave(position, vec2(0.732, 0.91), 10.0, 150.0);
 
 
 gl_FragColor = vec4( w * 0.116 );

}