#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


/*
 2D Noise functions by Patricio Gonzalez Vivo
*/

// 2D Random
float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners porcentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

float fbm(vec2 uv) {
 float a = 0.;
 a += noise(uv * 2.);
 a += noise(uv * 4.);
 a += noise(uv * 8.);
 a += noise(uv * 16.);
 a += noise(uv * 32.);
 return a;
} 

void main( void ) {
 vec2 uv = (2. * gl_FragCoord.xy - resolution) / min(resolution.x, resolution.y); 
 vec3 color = vec3(1.);
 float l = 0.;
 l = (.01 + .01 * uv.y * fbm(vec2(time * 2., uv.y))) / abs(uv.x + .2 * fbm(vec2(time / 5., uv.y / 4.)));
 l += (.01 + .01 * uv.y * fbm(vec2(time, uv.y))) / abs(uv.x + .2 * fbm(vec2(time / 3., uv.y / 8.)));
 gl_FragColor = vec4(color * l, 1.); 
}