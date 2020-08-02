/*
 @Author Waqasul Haq
 Twitter: @iridule
 ShaderToy: iridule
 Instagram: @the_iridule
*/

precision mediump float;
#define TUNNEL_DIST 500.

uniform float time;
uniform vec2 resolution;

float iTime;
vec2 iResolution;

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


/*
 Tunnel Scene
*/
vec3 color(in vec2 uv, float f, float a) {
    return vec3(a * noise(uv * f));
}

vec3 tunnel(vec2 uv, float s) {
    return vec3(length(uv * s));
}

float sinp(float a) {
 return 0.5 + sin(a) * 0.5;
}

mat2 rotate(float a) {
    return mat2(
     cos(a),
        sin(a),
        -sin(a),
        cos(a)
    );

}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {

 
    vec2 uv =(2. * fragCoord.xy - iResolution.xy) / iResolution.y;
    uv = rotate(iTime / 5.0) * uv;
 
    /*
  Map to unit circle based on distance function
 */
    float inv = 1. / (length(uv));
    vec2 uvp = uv * inv - vec2(2. * inv + 5. * iTime , 0.);
 
    // the underlying movement
    vec3 ambient = vec3(0., 0., .3);
    ambient *= color(uvp, 4., 1.);
 
    // twisting / glowing streaks
    vec3 glow = vec3(0., .9, .9);
    glow *= (color(uvp, 1.2, 1.) * length(uv));
 
    // adding highlights based on multiplying noise  functions
    vec3 highlights = vec3(0., 1., 2.);

    // smooth step allows us to control noise values
    highlights *= (1.0 - smoothstep(
        .1,
        .8,
        (color(uvp, 2., 5.) * length(uv * 1.)) * (color(uvp, 25., 5.) * length(uv * 1.))
        
    ));

 // adding values together
    vec3 final = vec3(
        ambient * tunnel(uv, 1.) +
        glow +
        highlights * tunnel(uv, 0.6)
    );

    fragColor = vec4(final, 1.);

}

void main() {
 iTime = time;
 iResolution = resolution;
 mainImage(gl_FragColor, gl_FragCoord.xy);
}