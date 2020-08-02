#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define res resolution

// mini raymarcher
// based on https://www.shadertoy.com/view/4dtfRs
// 2018-05-20

//--- primitives: http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

float sdSphere(vec3 p, float radius) 
{
  return length(p) - radius;
}

float udRoundBox( vec3 p, vec3 dim, float radius )
{
  return length(max(abs(p)-dim,0.0))-radius;
}

float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

//--- basic rotations

mat3 rotateX(float a) 
{
  return mat3(
    1.0, 0.0, 0.0,
    0.0, cos(a), sin(a),
    0.0, -sin(a), cos(a));
}

mat3 rotateY(float a) 
{
  return mat3(
    cos(a), 0.0, sin(a),
    0.0, 1.0, 0.0,
    -sin(a), 0.0, cos(a));
}

mat3 rotateZ(float a) 
{
  return mat3(
    cos(a), sin(a), 0.0,
    -sin(a), cos(a), 0.0,
    0.0, 0.0, 1.0);
}

//--- raymarcher
float trace(vec3 o, vec3 r, mat3 tf, inout vec3 color) 
{
    const vec3 color1 = vec3(1.2, 0.6, 0.0); 
    const vec3 color2 = vec3(0.2, 1.2, 0.8); 
    const vec3 color3 = vec3(0.5, 0.0, 1.4); 
    float t = 0.0,d,d2;
    vec3 boxDim = vec3(0.2, 0.75, 2.0);
    for (int i = 0; i < 32; i++) 
    {
     vec3 p = o + r * t;
        d = udRoundBox(tf*p, boxDim, 0.12 );
        d2 = 0.9*sdSphere(p, 1.2);
        if (d < d2) color = color1; else color = color2;
        d = min(d,d2);
        d2 = 0.9*sdTorus (tf * p, vec2(1.8,0.2));
        if (d2 < d) color = color3;
        d = min(d,d2);
        t += d;
    }
    return t;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) 
{    
    float atime = 0.3*time;
    
    vec2 ratio = vec2(res.x / res.y, 1.0);
    vec2 uv = ratio * (2.0*(fragCoord / res.xy) -1.0);
    vec2 mp = ratio * (2.0*(mouse) -1.0);

    vec3 p = vec3(uv, 0.0) + vec3(0.0, 0.0, 1.4);
    
    vec3 l = vec3(uv, 0.0) + vec3(mp, 3.0);
    vec3 n = normalize(p);
    
    vec3 lp = normalize(l - p);
    vec3 lc = vec3(dot(lp, n));
    vec3 color = vec3(1.0, 0.0, 0.0);
    
    vec3 r = normalize(p);
    vec3 o = vec3(0.0, 0.0, -4.0);
    
    float t = trace(o, r, rotateZ(atime) * rotateY(atime), color);
   
    float fog = 1.0 / (1.0 + t*t *0.1);
    
    color.b *= fog;
    vec3 fc = vec3(fog * lc * color);
    
    fragColor = vec4(fc, 1.0);
}

void main( void ) 
{
    mainImage (gl_FragColor, gl_FragCoord.xy);
}