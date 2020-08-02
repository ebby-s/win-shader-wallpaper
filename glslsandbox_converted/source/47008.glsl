#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

precision mediump float;
uniform float time; // time
uniform vec2  r; // resolution

void main(void){
    float r = abs(sin(time)); // *1
    float g = abs(cos(time));
    float b = (r + g) / 0.1; // *2
    gl_FragColor = vec4(r, g, b, 1.0);

}