#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform vec2 resolution;
uniform float time;

vec2 iResolution;
float iTime;

#define map(x, a, b, c, d) c + ((v - a) / (b - a)) * (d - c)

#define TWO_PI 6.28318530718
#define AMOUNT 500.
#define STEP AMOUNT / 1e5

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = (2. * fragCoord - iResolution.xy) / iResolution.y;
    vec3 color;
    float f = 0.;
    for (float i = 0.; i < AMOUNT; i++) {
        vec2 p = vec2(
            cos(2. * iTime + i * STEP * 2.) * .6,
         sin(iTime + i * STEP * 2.) * .6);
        float ii = (i * i) / 500.;
        f += 1e-5 / abs(length(uv + p) - i / 50000.) * ii;
        color = hsv2rgb(vec3(clamp(f /6., 0., 1.), 1., 0.9));
    }
    fragColor = vec4(color, 1.);
}

void main() {
 iResolution = resolution;
 iTime = time;
 mainImage(gl_FragColor, gl_FragCoord.xy);
}