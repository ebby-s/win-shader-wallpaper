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
    float a = sin(time-uv.x);
    float ac = cos(uv.x);
    float as = sin(a);
    float z = ac+as-sin(a);
    uv3 *= mat3(
        sin(a)-0.1, sin(z), 0.0,
        sin(a)-0.01, sin(z), 0.0,
        0.0, 0.0, 1.0);
    uv.x = uv3.x;
    uv.y = uv3.y;

    uv = mod(uv, 0.2) * 5.0-sin(z-ac);

    gl_FragColor = vec4(uv, sin(z)*as, 1.0+sin(z));
}