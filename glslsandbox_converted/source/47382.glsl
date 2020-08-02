#ifdef GL_ES 
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform vec2 resolution;
uniform float time;

vec2 iResolution;
float iTime;

#define rotate(a) mat2(cos(a), sin(a), -sin(a), cos(a))
#define spiral(u, a, r, t, d) abs(sin(t + r * length(u) + a * (d * atan(u.y, u.x))))
#define sinp(a) .5 + sin(a) * .5


void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
 
    vec2 st = (2. * fragCoord - iResolution.xy) / iResolution.y;
  st = rotate(-iTime / 10.) * st;
 
 vec3 col;
 float t = iTime;
    vec2 o = vec2(cos(iTime / 10.), sin(iTime / 2.));
 for (int i = 0; i < 3; i++) {
  t += 0.3 * spiral(vec2(o + st), 16., 16. + 64. * o.x - o.y, -iTime / 100., 1.)
            * spiral(vec2(o - st), 16., 16. + 64. * o.x - o.y, iTime / 100., -1.);
  col[i] = sin(5. * t - length(st) * 10. * sinp(t));
 }
 
 fragColor = vec4(col, 1.0);
    
}


void main() {
 iResolution = resolution;
 iTime = time;
 mainImage(gl_FragColor, gl_FragCoord.xy);
}