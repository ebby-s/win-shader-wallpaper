#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 resolution;

vec2 position(float z) {
    return vec2(
        0.0 + sin(z * 0.1) * 1.0 + sin(cos(z * 0.031) * 4.0) * 1.0 + sin(sin(z * 0.0091) * 3.0) * 3.0,
        0.0 + cos(z * 0.1) * 1.0 + cos(cos(z * 0.031) * 4.0) * 1.0 + cos(sin(z * 0.0091) * 3.0) * 3.0
    ) * 1.0;
}

void main( void ) 
{
    vec2 p = (gl_FragCoord.xy*0.5-resolution)/min(resolution.x,resolution.y);
    float x = 1.00;
    float m = 3.0;
    float camZ = 25.0 * time * x;
    vec2 cam = position(camZ);

    float dt = 1.0;
    float camZ2 = 25.0 * (time + dt) * x;
    vec2 cam2 = position(camZ2);
    vec2 dcamdt = (cam2 - cam) / dt;
    
    vec3 f = vec3(0.0);
    for(int j = 1; j < 300; j++) {
        float i = float(j);
        float realZ = floor(camZ) + i;
        float screenZ = realZ - camZ;
        float r = 1.0 / screenZ;
        vec2 c = (position(realZ) - cam) * 10.0 / screenZ - dcamdt * 0.4;
        vec3 color = (vec3(sin(realZ * 0.07), sin(realZ * 0.1), sin(realZ * 0.08)) + vec3(1.0)) / 2.0;
        float ang = atan((p - c).y, (p - c).x);
        r += sin((ang + time) * 10.0 + realZ * 13.2) * 0.01 * m
           + sin(ang * 20.0 + realZ * 64.7  + time) * 0.005 * m
           + sin((ang - time) * 30.0 + realZ * 239.9 + time) * 0.0025 * m;
        f += color * 0.06 / screenZ / (abs(length(p - c) - r) + 0.01);
    }

    gl_FragColor = vec4(f, 1.0);
}