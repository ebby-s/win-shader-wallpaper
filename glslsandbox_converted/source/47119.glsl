#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int Iterations = 320;
const float CollisionThreshold = 0.001;

float distSphere(float radius, vec3 p) { return length(p) - radius; }
float distBox(vec3 size, vec3 p) { return length(max(abs(p) - size, vec3(0))); }
vec3 boxNormal(vec3 size, vec3 p, float d)
{
 float xd = distBox(size, p + vec3(0.0001, 0, 0)) - d;
 float yd = distBox(size, p + vec3(0, 0.0001, 0)) - d;
 float zd = distBox(size, p + vec3(0, 0, 0.0001)) - d;
 return normalize(vec3(xd, yd, zd));
}

vec3 foldx(vec3 i) { i.x = abs(i.x); return i; }
mat2 rmat(float deg)
{
 float s = sin(deg), c = cos(deg);
 return mat2(c, s, -s, c);
}

float distRoundBoxes(vec3 p)
{
 float d = distBox(vec3(1.0, 0.1, 100), p);
 for(int i = 0; i < 4; i++)
 {
  p.y = mod(-p.y, 1.6); p -= vec3(-3, 0, 0); p.x = -abs(p.x); p.xy *= rmat(0.15);
  d = min(d, distBox(vec3(1.0, 0.5, 100), p));
 }
 return d;
}

struct MinDistanceSurfaceInfo { float d; vec3 normal; };
MinDistanceSurfaceInfo detectNearest(vec3 p)
{
 MinDistanceSurfaceInfo ms;
 float d = distSphere(0.6, foldx(p) - vec3(0.5, 0, 10));
 ms.d = d; ms.normal = normalize(foldx(p) - vec3(0.5, 0, 10));
 
 d = distRoundBoxes(p);
 if(d < ms.d) { ms.d = d; }
 return ms;
}

void main( void )
{
 vec3 pos = vec3(0, 0, -2);
 vec3 ray = normalize(vec3(vec2(resolution.x / resolution.y, 1.0) * (gl_FragCoord.xy / resolution.xy - 0.5), 0) - pos);
 ray.xy *= rmat(0.3 * time);
 pos.z -= time * 0.3 / 50.0;
 
 for(int n = 0; n < Iterations; n++)
 {
  MinDistanceSurfaceInfo ms = detectNearest(pos);
  if(ms.d <= CollisionThreshold)
  {
   gl_FragColor = vec4(vec3(float(n) / 35.0) * vec3(0.75, 0.75, 1.0)/* * ms.normal*/, 1);
   return;
  }
  pos += ray * ms.d;
 }
 gl_FragColor = vec4(0);

}