#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
void main(void) {
 vec2 texcoord = gl_FragCoord.xy / resolution.xy;
      //texcoord = vec2(0.5);
 
 

 
    vec2 uv = gl_FragCoord.xy /
        min(resolution.x, resolution.y);

    uv = uv * 1.0 - 1.;

    vec3 uv3 = vec3(uv, 0.0);
    float a = (time-uv.x)/2.;
    float ac = cos(uv.x)*3.;
    float as = sin(a)-sin(ac);
    float z = ac+as-sin(a);
 vec3 color = sin(time)*sin(vec3(texcoord.x * 2.0 - a, texcoord.y * 2.0 - 1.0, (1.0 - texcoord.y) * -a - 1.0) + 1.0)*1.0-1.0;
    uv3 *= mat3(
        sin(a)-0.1, sin(z), 0.0,
        sin(a)-0.01,sin( z), 0.0,
        0.0, 0.0, 1.0);
    uv.x = uv3.x;
    uv.y = uv3.y-sin(time/9.);

    uv = mod(uv, 0.2) * 5.0;
gl_FragColor = vec4((color*sin(uv.x-time)), 1.0 );
    //gl_FragColor = vec4(uv-sqrt(uv.x*uv.y), sin(a), z);
}