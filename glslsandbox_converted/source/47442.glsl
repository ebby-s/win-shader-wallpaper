
#ifdef GL_ES
precision lowp float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.1415927
#define PI2 (PI*2.0)

// http://glsl.heroku.com/e#7109.0 simplified by logos7@o2.pl

void main(void)
{
    vec2 position = 0.4*(2.0 * gl_FragCoord.xy - resolution);

    float r = (0.1+mouse.x) * length(position);
    float a = atan(position.y, position.x);
    float d = r - a + PI;
    float n = PI2 * floor(d / PI2);
    float k = a + n;
    float rand = sin(.6*(0.15 * k * k + (2.3*time)));

    gl_FragColor.rgba = vec4(2.*rand*vec3(2.0), 1.0);
}