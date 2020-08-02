
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
    vec2 position = 100.0 * ((2.0 * gl_FragCoord.xy - resolution) / resolution.xx);

    float r = 2.0*length(position);
    float a = atan(position.y, position.x);
    float d = r - a + PI2;
    float n = PI2 * float(int(d / PI2));
    float k = a + n;
    float rand = sin(1.0*floor(0.15
      * k * k + (0.3*time)));

    gl_FragColor.rgba = vec4((1.5*time)*rand*vec3(1.0, 1.0, 01.0), 1.0);
}