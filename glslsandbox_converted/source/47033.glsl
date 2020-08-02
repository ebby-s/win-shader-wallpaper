#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
// example from https://www.shadertoy.com/view/4tlGD4
/**
 * I wrote this function years ago. Or did I take it from
 * somewhere? I can't remember... If you know this, please
 * write it in the comments!
 */
float cloud (vec2 pos, float t)
{
    float dx = 0.5 + 0.25 * ( cos (pos.x*5.0 + 11.0*sin (t*0.05)) 
                            + sin (pos.y*3.0 + 11.0*cos (t*0.11)) );
    float dy = 0.5 + 0.25 * ( cos (pos.x*4.0 + 11.0*sin (t*0.11)) 
                            + sin (pos.y*4.0 + 11.0*cos (t*0.05)) );
    return 0.5 + 0.5*sin (dx*2.0 * sin (dy*2.0 + 0.1*t) + 0.1*t);
}

vec3 smoke (vec2 p, float t)
{
    float a = (1.0 - p.y) * cloud (p, t * 3.0);
    
    if (a < 0.3)
    {
        vec3 m = vec3 (0.0, 0.0, 0.0);
        vec3 n = vec3 (0.4, 0.2, 0.15);
        return mix (m, n, a / 0.3);
    }
    else if (a < 0.5)
    {
        vec3 m = vec3 (0.4, 0.2, 0.15);
        vec3 n = vec3 (0.4, 0.3, 0.25);
        return mix (m, n, (a - 0.3) / 0.2);
    }
    else
    {  
        vec3 m = vec3 (0.4, 0.3, 0.25);
        vec3 n = vec3 (0.7, 0.5, 0.4);
        return mix (m, n, (a - 0.5) / 0.5);
    }
}

float flame (vec2 p, float t)
{
    vec2 p2;
    p2.x = 2.0 * sin (8.0 * p.x);
    p2.y = p.y;
    return (1.0 - abs (0.5 - p.x)) * (1.0 - 0.5 * p.y) * cloud (p2, t * 20.0);
}

vec4 flames (vec2 p, float t)
{
    float f = 0.0;
    vec2 p2 = p;
    float t2 = t;
    float w = 1.0;
    float sum = 0.0;
    
    for (float i = 0.0; i < 10.0; i++)
    {
        f += w * flame (p2, t2);
        p2.y -= 0.08;
        t2 -= 2.0;
        sum += w;
        w *= 0.9;
    }
    
    f /= sum;
    
    if (f < 0.5)
    {
        return vec4 (0.0);
    }
    else
    {
        vec4 m = vec4 (0.5, 0.5, 0.1, 0.0);
        vec4 n = vec4 (1.0, 1.0, 0.1, 1.0);
        return mix (m, n, (f - 0.5) / 0.5);
    }
}


void main( void ) {
vec2 p = gl_FragCoord.xy / resolution.xy;
    
    vec4 f = flames (p, time);
    vec3 s = smoke (p, time);

    s *= 1.0 - f.a;
    f *= f.a;
    gl_FragColor = f + vec4 (s, 1.0);
 
}