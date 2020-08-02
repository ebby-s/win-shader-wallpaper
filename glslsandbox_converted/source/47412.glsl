#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// interactive solar-vixzion by iridule

// https://www.shadertoy.com/view/MsGBDh

// adaptions by i.g.p

#define TWO_PI 6.28318530718
#define rotate(a) mat2(cos(a), sin(a), -sin(a), cos(a))
#define spiral(u, a, r, t, d) abs(sin(t + r * length(u) + a * (d * atan(u.y, u.x))))
#define flower(u, a, r, t) spiral(u, a, r, t, 1.) * spiral(u, a, r, t, -1.)
#define sinp(a) .5 + sin(a) * .5
#define polar(a, t) a * vec2(cos(t), sin(t))


void mainImage( out vec4 fragColor, in vec2 fragCoord ) 
{
    vec2 st = (2. * fragCoord - resolution.xy) / resolution.y;
    st = rotate(-time / 10.) * st;
 
    vec3 col;
    vec2 o = vec2(cos(time / 22.), sin(time / 2.));
    vec2 v;
    
    float t = -.001*time;
    vec2 mp = 1.+4.*mouse.xy;
    
    for (int i = 0; i < 10; i++) {
        for (float i = 0.; i < TWO_PI; i += TWO_PI / 16.) {
            t += .6 * flower(vec2(st + polar(1., i)), 6.+mp.x, (4.4+mp.y) * 
                             sinp(time / 2.), time / 4.);
        }
  col[i] = sin(5. * t + length(st) * 8. * sinp(t));
 }
 
 fragColor = vec4(mix(col, vec3(1., .7, 0.), col.r), 1.0);
    
}

void main( void ) 
{
 mainImage( gl_FragColor, gl_FragCoord.xy );
}


