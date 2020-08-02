#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 wavedx(vec2 uv, vec2 emitter, float speed, float phase, float timeshift){
    float x = distance(uv, emitter) * phase - timeshift * speed;
    float wave = exp(sin(x) - 1.0);
    float dx = wave * cos(x);
    return vec2(wave, dx);
}
vec2 wavetadalala(vec2 position, vec2 direction, float speed, float frequency, float timeshift) {
    direction = normalize(direction);
    float x = dot(direction, position) * frequency + timeshift * speed * frequency * 0.333333;
    float wave = exp(sin(x) - 1.0);
    float dx = wave * cos(x);
    return vec2(wave, dx);
}

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy );
float w  = 0.0;
 
 if(position.y <0.5){
  w = wavedx(position * 100.0, normalize(mouse * 2.0 - 1.0) * 10000.0, 2.0, 3.0, time * 1.0).x;
 } else {
  w = wavetadalala(position * 100.0, normalize(mouse * 2.0 - 1.0) * 10000.0, 2.0, 3.0, time * 1.0).x;
 }

 gl_FragColor = vec4( w * 0.25 );

}