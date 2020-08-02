// https://www.shadertoy.com/view/Xds3zN
// The MIT License
// Copyright \u00a9 2013 Inigo Quilez
// \u672c\u30d7\u30ed\u30b0\u30e9\u30e0\u306f\u4e0a\u8a18\u30d7\u30ed\u30b0\u30e9\u30e0\u3092\u6539\u5909\u3057\u305f\u3082\u306e\u3067\u3042\u308b\u3002

#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

#define M_GETA   1.0
#define M_SHARI  2.0
#define M_MAGURO 3.0

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Signed Distance Functions

float sdSphere(vec3 p, float s)
{
 return length(p)-s; 
}

float udBox(vec3 p, vec3 b)
{
 return length(max(abs(p)-b, 0.0));
}

float udRoundBox(vec3 p, vec3 b, float r)
{
 return length(max(abs(p)-b, 0.0)) - r;
}

float sdTorus(vec3 p, vec2 t)
{
 vec2 q = vec2(length(p.xz)-t.x,p.y);
 return length(q)-t.y;
}

float sdCylinder(vec3 p, vec3 c)
{
 return length(p.xz-c.xy) - c.z;
}

float sdPlane(vec3 p, vec4 n)
{
 return dot(p, n.xyz) + n.w;
}

float sdCapsule(vec3 p, vec3 a, vec3 b, float r)
{
 vec3 pa = p - a;
 vec3 ba = b - a;
 float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
 return length(pa - ba * h) - r;
}

float sdEllipsoid(vec3 p, vec3 r)
{
 return (length(p / r) - 1.0) * min(min(r.x, r.y), r.z);
}

float length2(vec2 p)
{
 return sqrt(p.x * p.x + p.y + p.y);
}

float length6(vec2 p)
{
 p = p * p * p; p = p * p;
 return pow(p.x + p.y, 1.0 / 6.0);
}

float length8( vec2 p )
{
 p = p * p; p = p * p; p = p * p;
 return pow(p.x + p.y, 1.0 / 8.0);
}

float sdTorus82(vec3 p, vec2 t)
{
    vec2 q = vec2(length2(p.xz) - t.x, p.y);
    return length8(q) - t.y;
}

// Operations

vec2 opU(vec2 d1, vec2 d2)
{
 return (d1.x < d2.x) ? d1 : d2;
}

float opS(float d1, float d2)
{
 return max(-d2, d1);
}

float opI(float d1, float d2)
{
 return max(d1, d2);
}

vec3 opRep(vec3 p, vec3 c)
{
 return mod(p, c) - 0.5 * c;
}

// 3D Models

vec2 shari(vec3 p)
{
 return vec2(udRoundBox(p, vec3(0.1, 0.1, 0.22), 0.005), M_SHARI);
}

vec2 maguro(vec3 p)
{
 vec2 res = vec2(udRoundBox(p - vec3(0.0, 0.1, 0.0), vec3(0.13, 0.04, 0.3), 0.005), M_MAGURO);
 return opU(res, shari(p));
}

vec2 geta(vec3 p)
{
 vec2 tmp = opU(vec2(udRoundBox(p - vec3(0.5, -0.2, 0.0), vec3(0.1, 0.1, 0.5), 0.005), M_GETA),
         vec2(udRoundBox(p - vec3(-0.5, -0.2, 0.0), vec3(0.1, 0.1, 0.5), 0.005), M_GETA));
 return opU(vec2(udRoundBox(p, vec3(0.8, 0.1, 0.5), 0.01), M_GETA),
     tmp);
}

vec2 map(vec3 p)
{
 vec3 pos = p;
 vec2 res = vec2(50.0);
  pos = opRep(p, vec3(2.0));
 res =  geta(pos);
 res = opU(res, maguro(pos - vec3(0.0, 0.2, 0.0)));
 return res;
}

// Rendering Functions

vec2 castRay(vec3 ro, vec3 rd)
{
 float tmin = 1.0;
 float tmax = 20.0;
 
 float t = tmin;
 float m = -1.0;
 for (int i = 0; i < 64; i++) {
  float precis = 0.0004 * t;
  vec2 res = map(ro + rd * t);
  if (res.x < precis || t > tmax)
   break;
  t += res.x;
  m = res.y;
 }
 if (t > tmax)
  m = -1.0;
 return vec2(t, m);
}

vec3 calcNormal(vec3 p)
{
 vec2 e = vec2(1.0, -1.0) * 0.5773 * 0.0005;
 return normalize(e.xyy * map (p + e.xyy).x + 
    e.yxy * map (p + e.yxy).x + 
    e.yyx * map (p + e.yyx).x + 
    e.xxx * map (p + e.xxx).x);
}

vec3 render(vec3 ro, vec3 rd)
{
 vec3 col = vec3(0.7, 0.9, 1.0) + rd.y * 0.8;
 vec2 res = castRay(ro, rd);
 float t = res.x;
 float m = res.y;
 vec3 p = ro + t * rd;
 
 // description \u30e1\u30e2 res.y \u306e\u5024\u3054\u3068\u306b\u8272\u306e\u51e6\u7406
 if (m < 0.0)
  return col;
 if (m == M_GETA)
  col = vec3(1, 1, 1);
 if (m == M_SHARI)
  col = vec3(0.8);
 if (m == M_MAGURO)
  col = vec3(0.8, 0.2, 0.2);
 
 vec3 lig = normalize(vec3(-0.4, 0.7, -0.6));
 vec3 nor = calcNormal(p);
 float amb = clamp(0.5 + 0.5 * nor.y, 0.0, 1.0);
 float dif = clamp(dot(nor, lig), 0.0, 1.0);
 
 
 vec3 lin = vec3(0.0);
        lin += 1.30 * dif * vec3(1.00, 0.80, 0.55);
        lin += 0.40 * amb * vec3(0.40,0.60,1.00);
 col *= lin;
 
 return col;
}

mat3 setCamera(vec3 ro, vec3 ta, float cr)
{
 vec3 cw = normalize(ta - ro);
 vec3 cp = vec3(sin(cr), cos(cr), 0.0);
 vec3 cu = normalize(cross(cw, cp));
 vec3 cv = normalize(cross(cu, cw));
 return mat3(cu, cv, cw);
}

void main()
{
 vec2 mo = mouse.xy / resolution.xy;
 vec3 col = vec3(0.0);
 vec2 p = (-resolution.xy + gl_FragCoord.xy * 2.0) / resolution.y;
 
 // camera
 vec3 ro = vec3(-0.5 + 3.5 * cos(0.1 * time + 6.0 * mo.x),
         2.0 + 2.0 * mo.y,
         0.5 + 4.0 * sin(0.1 * time + 6.0 * mo.x) );
        vec3 ta = vec3(0.0, 0.0, 0.0);
 mat3 ca = setCamera(ro, ta, 0.0);
 vec3 rd = ca * normalize(vec3(p.xy, 2.0));
 
 col += render(ro, rd);
 
 col = pow(col, vec3(0.4545));

 gl_FragColor = vec4(col, 1.0);

}