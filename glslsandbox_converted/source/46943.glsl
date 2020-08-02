//Modified by Vlad 03/05/2018
//Hacking in some basic texturing, based on the awsome shadertoy PSX rendering demo: https://www.shadertoy.com/view/Mt3Gz2
//HOWEVER, the uv perspective transformations are incorrect, so if anybody has any ideas on how to fix them, please fork away ;) 
// Good ref: http://web.cs.ucdavis.edu/~amenta/s12/perspectiveCorrect.pdf

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.1415
#define TAU PI * 2.00

//I know, there is no less effiecient way of implementing per-pixel 3D graphics
//Vlad: Any better suggestions? 
mat4 view = mat4(1), pMatrix;
vec2 clipspace;

float near = 0.1;
float far = 100.0;
float zoom = 2.0;

vec3 colorBuffer = vec3(135, 206, 235) / 255.;
float depthBuffer = 1.0;

void translate(vec3 pos)
{
 view *= mat4(
  1, 0, 0, 0,
  0, 1, 0, 0,
  0, 0, 1, 0,
  pos, 1
 ); 
}

float hash( vec2 p ) 
{
   float h = dot(p,vec2(127.1,311.7)); 
    return fract(sin(h)*43758.5453123);
}

float noise1(vec2 p) 
{
    #ifndef BILINEAR
  return hash(floor(p));
    #else    
        vec2 i = floor(p);
        vec2 f = fract(p);
     vec2 tx = mix(vec2(hash(i),hash(i+vec2(0.,1.))) ,
                      vec2(hash(i+vec2(1.,0.)),hash(i+vec2(1.))),f.x);
        return mix(tx.x,tx.y,f.y);
    #endif
}

vec4 textureBox(vec2 uv) 
{
    const vec2 RES = vec2(8.0, 8.0);
    vec2 iuv = (floor(uv * RES) + 0.5) / RES;  
    //vec2 iuv = uv / RES;  
    float n = noise1(uv * RES);
    n = max(abs(iuv.x - 0.5), abs(iuv.y - 0.5)) * 2.0;
    n = n * n;
    n = 0.5 + n * 0.4 + noise1(uv * RES) * 0.1;
    return vec4(n, n*0.8, n*0.5, 1.0);
 //return vec4(uv.x, uv.y, 1.0, 1.0); //debug
}

void scale(vec3 pos)
{
 view[0] *= pos.x;
 view[1] *= pos.y;
 view[2] *= pos.z;
}

void rotate (vec3 u, float a)
{
 u = normalize(u);
 float s = sin(a), c = cos(a), c1 = 1. - c;
 
 view *= mat4 (
  c + u.x * u.x * c1, u.x * u.y * c1 - u.z * s, u.x * u.z * c1 + u.y * s, 0,
  u.y * u.x * c1 + u.z * s, c + u.y * u.y * c1, u.y * u.z * c1 - u.x * s, 0,
  u.z * u.x * c1 - u.y * s, u.z * u.y * c1 + u.x * s, c + u.z * u.z * c1, 0,
  0, 0, 0, 1
 );
}

mat4 perspective (float FOV, float aspectRatio, float _near, float _far)
{
 float f = 1.0 / tan(FOV / 2.0);
 float nf = _near - _far;
 
 return mat4(f / aspectRatio, 0, 0, 0,
 0, f, 0, 0,
 0, 0, (_far + _near) / nf, -1,
 0, 0, (2.0 * _far * _near) / nf, 0);
}


vec3 setView (mat4 view, vec3 pos)
{
 vec4 c = view * vec4(pos, 1);
 
 return c.xyz / c.w;
}

void tri(vec3 color, vec3 p0, vec3 p1, vec3 p2, bool firstTriangle)
{
 vec3 vp0 = setView(pMatrix *view, p0);
 vec3 vp1 = setView(pMatrix *view, p1);
 vec3 vp2 = setView(pMatrix *view, p2);
       
 vec2 v0 = vp2.xy - vp0.xy;
 vec2 v1 = vp1.xy - vp0.xy;
 vec2 v2 = clipspace - vp0.xy;
 
 float dot00 = dot(v0, v0);
 float dot01 = dot(v0, v1);
 float dot02 = dot(v0, v2);
 float dot11 = dot(v1, v1);
 float dot12 = dot(v1, v2);

 float f = 1.0 / (dot00 * dot11 - dot01 * dot01);
 
 //Todo: Figure out how to compute the perspective corrections for the UV coordinates
 
 float u = (dot11 * dot02 - dot01 * dot12) * f;
 float v = (dot00 * dot12 - dot01 * dot02) * f;
 float w = 1.0 - u - v;
 
  
 if (u >= 0. && v >= 0. && w >= 0.)
 {
  p0 = setView(view, p0);
  p1 = setView(view, p1);
  p2 = setView(view, p2);

  float depth = vp0.z * w + vp1.z * v + vp2.z * u;
  vec3 pos = p0 * w + p1 * v + p2 * u;
  

  //LEQUAL OpenGL Equivelent
  if (depthBuffer >= depth && depth >= -1.0)
  {
   //lighting
   vec3 normal = normalize(cross (p1 - p0, p0 - p2));
   vec3 npos = normalize(pos);
   

   //Mirror UV's
   if(firstTriangle)
   {
    color = textureBox(vec2(u, v)).xyz * dot(npos, normal);
   }
   else
   {
    color = textureBox(vec2(1.0 - v, 1.0 - u)).xyz * dot(npos, -normal); //Flip UV coordinates and subtract from upper right triangle (do the same for the normals)
   }
   
   depthBuffer = depth;
   colorBuffer = color;
  }
 }
}

void quad(vec3 color, vec3 p1, vec3 p2, vec3 p3, vec3 p4)
{
 tri(color, p1, p2, p3, true);
 tri(color, p4, p2, p3, false);
}

void drawScene()
{
 translate(vec3(0, 0, -5));
 
 rotate(vec3(0, 1, 0), time);
 
 {
  mat4 cache = view;
  view = mat4(view);
  
  translate (vec3(0, abs(sin(time / 2. * TAU)) * 2. - 1., 0));
  rotate(vec3(1, 0, 1), -time * PI);
  
  quad(vec3(1, 0, 1), vec3(-1, -1, 1), vec3(1, -1, 1), vec3(-1, 1, 1), vec3(1, 1, 1));
  quad(vec3(1, 1, 0), vec3(-1, -1, -1), vec3(-1, 1, -1), vec3(1, -1, -1), vec3(1, 1, -1));
  
  quad(vec3(0, 0, 1), vec3(1, -1, -1), vec3(1, 1, -1), vec3(1, -1, 1), vec3(1, 1, 1));
  quad(vec3(0, 1, 0), vec3(-1, -1, -1), vec3(-1, -1, 1), vec3(-1, 1, -1), vec3(-1, 1, 1));
  
  quad(vec3(1, 0, 0), vec3(-1, 1, -1), vec3(-1, 1, 1), vec3(1, 1, -1), vec3(1, 1, 1));
  quad(vec3(0, 1, 1), vec3(-1, -1, -1), vec3(1, -1, -1), vec3(-1, -1, 1), vec3(1, -1, 1));
  
  view = cache;
 }
 
 {
  mat4 cache = view;
  view = mat4(view);
  
  translate(vec3(0, -2, 0));
  
  quad(vec3(1, 1, 1), vec3(-2, 0, -2), vec3(-2, 0, 2), vec3(2, 0, -2), vec3(2, 0, 2));
  quad(vec3(89, 26, 20) / 100., vec3(-3, -0.01, -3), vec3(-3, -0.01, 3), vec3(3, -0.01, -3), vec3(3, -0.01, 3));
  
  view = cache;
 }
}

void main( void ) 
{
 clipspace = gl_FragCoord.xy / resolution * 2.0 - 1.0;
 pMatrix = perspective(PI / zoom, resolution.x / resolution.y, near, far);
 
 drawScene();
 
 gl_FragColor = vec4(colorBuffer, 1);
}