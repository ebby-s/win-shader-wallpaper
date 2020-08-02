#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
float wave(vec2 p)
{
 float v = sin(p.x+sin(p.y) + sin(p.y*.43));
 return v*v;
}
const mat2 rot=mat2(.5,.86,-.86,.5);
const float speed = 1.1;
float map(vec2 p)
{
 float v=0.;
 v+=wave(p);
 p.x+=time * speed;p*=rot;
 v+=wave(p);
 p.x+=time* speed * .17;
 p*=rot;
 v+=wave(p);
 v=abs(1.5-v);
 return v;
}
void main(void) {
    vec2 uv = gl_FragCoord.xy /
        min(resolution.x, resolution.y);

    uv = uv * 1.0 - 1.;

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
    uv.y = uv3.y-sin(time/4.);

    uv = mod(uv, 0.2) * 5.0;
vec2 p=normalize(vec3(uv.xy,2.3)).xy*10.;p.y+=time*speed*.3;
 float v=map(p);
    gl_FragColor = vec4(uv-sin(uv.y*v-10.), v, .5);
}