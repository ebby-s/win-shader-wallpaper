#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 resolution;

// example from https://www.shadertoy.com/view/Xl2cR3
void main( void ) {
vec2 uv = gl_FragCoord.xy / resolution.xy;
 
    float f3 = 1.0 - abs(uv.y + sin(uv.x * 1.618033 * 4.0 + time)*0.5 - 0.5);
    float f2 = 1.0 - abs(uv.y + sin(uv.x * 1.618033 * 3.0 + time)*0.5 - 0.5);
    float f = 1.0 - abs(uv.y + sin(uv.x * 1.618033 * 2.0 + time)*0.5 - 0.5);
    vec4 color = vec4(pow(f,1.0)*pow(f2,3.0), f*f*f*f2, pow(f3,1.0) * f2 * f,1.);
    
    gl_FragColor = color;
 

}