#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define pi 3.1415962
uniform vec2 resolution;
uniform float time;
void main(void) {
    vec2 uv = gl_FragCoord.xy /
        min(resolution.x, resolution.y);

    uv = uv * 1.0 - 1.;
    float r = length(uv);
    float ax = (atan(uv.x,uv.y)/2./pi+.5)*2.*pi;
    vec3 uv3 = vec3(uv, 0.0);
    float a = (time-uv.x)/2.;
    float ac = cos(uv.x)*3.;
    float as = sin(a);
    float z = ac+as-sin(a);
    uv3 *= mat3(
        sin(a)-0.1, sin(z), 0.0,
        sin(a)-0.01,sin( z), 0.0,
        0.0, 0.0, 1.0);
    uv.x = uv3.x;
    uv.y = uv3.y-sin(time/10.0);

    uv = mod(uv, 0.2) * 5.0;

    gl_FragColor = vec4(uv-sin(uv.y*uv.x)+r*sin(time+ax), 0.0, 0.0);
}