#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
void main(void) {
    vec2 uv = gl_FragCoord.xy /
        min(resolution.x, resolution.y);

    uv = uv * 1.0 - 1.;

    vec3 uv3 = vec3(uv, 0.0);
    float a = (time-uv.x)/2.;
    float ac = cos(uv.x)*1.;
    float as = sin(a);
    float z = ac+as-sin(a);
    uv3 *= mat3(
        sin(a)-0.1, tan(z), 0.0,
        as,tan( z), 0.0,
        0.0, 0.0, 1.0);
    uv.x = uv3.x;
    uv.y = uv3.y-sin(time/7.);

    uv = mod(uv, 0.8) * fract(cos(uv.x-cos(time))*3.0);

    gl_FragColor = vec4(uv-(uv.x-sin(time)), .1+sin(time), 2);
}