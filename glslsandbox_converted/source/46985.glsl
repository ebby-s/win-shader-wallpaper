#ifdef GL_ES
precision highp float;
#endif

uniform float   time;
uniform vec2   mouse;
uniform vec2   resolution;
uniform sampler2D  renderbuffer;

//GDC 2016


//#define SLIDE_PYTHAGORAS
//#define SLIDE_DISTANCE_FUNCTIONS
//#define SLIDE_DISTANCE_OPERATIONS
//#define SLIDE_CAMERA
//#define SLIDE_RAY_STEPS
//#define SLIDE_DERIVE_NORMALS
#define SLIDE_LIGHTS_AND_MATERIALS

//distance functions
#ifdef SLIDE_PYTHAGORAS
 #define SCENE_PYTHAGORAS
 #define PLOT_MAP   1.
 #define MAP_DISTANCE    PLOT_MAP * 1.
 #define MAP_MANIFOLD    PLOT_MAP * 2.
 #define MAP_CONTOUR    PLOT_MAP * .25 
 #define RAYS     1
 #define ITERATIONS    1
 #define THRESHOLD   .01
 #define FARPLANE    4.
 #define SCALE    (mouse.x < .5 ? 1. : 1.)
 #define ORTHOGRAPHIC   (mouse.x < .5)
 #define FOV    (mouse.x > .85 ? mouse.y * 8. : 3.5)
 #define VIEWPOINT   vec2(-1.75, 0.)
 #define VIEWTARGET   vec2(1., 0.)
 #define LIGHT_POSITION   vec2(-.5, .95)
 #define LIGHT_COLOR   vec3(.75, .75, .45)
 #define OCCLUSION_ITERATIONS  0
 #define SHADOW_ITERATIONS  0
#endif



//distance functions
#ifdef SLIDE_DISTANCE_FUNCTIONS
 #define SCENE_DISTANCE_FUNCTIONS
 #define PLOT_MAP   1.
 #define MAP_DISTANCE    PLOT_MAP * 1.
 #define MAP_MANIFOLD    PLOT_MAP * 2.
 #define MAP_CONTOUR    PLOT_MAP * .25 
 #define RAYS     1
 #define ITERATIONS    1
 #define THRESHOLD   .01
 #define FARPLANE    4.
 #define SCALE    (mouse.x < .5 ? 1. : 1.)
 #define ORTHOGRAPHIC   (mouse.x < .5)
 #define FOV    (mouse.x > .85 ? mouse.y * 8. : 3.5)
 #define VIEWPOINT   vec2(-1.75, 0.)
 #define VIEWTARGET   vec2(1., 0.)
 #define LIGHT_POSITION   vec2(-.5, .95)
 #define LIGHT_COLOR   vec3(.75, .75, .45)
 #define OCCLUSION_ITERATIONS  0
 #define SHADOW_ITERATIONS  0
#endif


//distance functions
#ifdef SLIDE_DISTANCE_OPERATIONS
 #define SCENE_DISTANCE_OPERATIONS
 #define PLOT_MAP   1.
 #define MAP_DISTANCE    PLOT_MAP * 1.
 #define MAP_MANIFOLD    PLOT_MAP * 2.
 #define MAP_CONTOUR    PLOT_MAP * .25 
 #define RAYS     1
 #define ITERATIONS    1
 #define THRESHOLD   .01
 #define FARPLANE    4.
 #define SCALE    (mouse.x < .5 ? 1. : 1.)
 #define ORTHOGRAPHIC   (mouse.x < .5)
 #define FOV    (mouse.x > .85 ? mouse.y * 8. : 3.5)
 #define VIEWPOINT   vec2(-1.75, 0.)
 #define VIEWTARGET   vec2(1., 0.)
 #define LIGHT_POSITION   vec2(-.5, .95)
 #define LIGHT_COLOR   vec3(.75, .75, .45)
 #define OCCLUSION_ITERATIONS  0
 #define SHADOW_ITERATIONS  0
#endif


//camera
#ifdef SLIDE_CAMERA
 #define SCENE_SPHERES
 #define PLOT_MAP   1.
 #define MAP_DISTANCE    PLOT_MAP * 1.
 #define MAP_MANIFOLD    PLOT_MAP * 2.
 #define MAP_CONTOUR    PLOT_MAP * .25 
 #define PLOT_RAYS   1.
// #define RAY_POSITION   PLOT_RAYS * 2.
 #define RAY_PATH   PLOT_RAYS * 1.
// #define RAY_DISTANCE   PLOT_RAYS * 1.
 #define RAYS     32
 #define ITERATIONS    32
 #define THRESHOLD   .01
 #define FARPLANE    4.
 #define SCALE    (mouse.x < .5 ? 1. : 1.)
 #define ORTHOGRAPHIC   (mouse.x < .5)
 #define FOV    (mouse.x > .85 ? mouse.y * 8. : 3.5)
 #define VIEWPOINT   vec2(-1.75, 0.)
 #define VIEWTARGET   vec2(1., 0.)
 #define LIGHT_POSITION   vec2(-.5, .95)
 #define LIGHT_COLOR   vec3(.75, .75, .45)
 #define OCCLUSION_ITERATIONS  0
 #define SHADOW_ITERATIONS  0
#endif

//ray stepping
#ifdef SLIDE_RAY_STEPS
 #define SCENE_SPHERES
 #define PLOT_MAP   1.
 #define MAP_DISTANCE    PLOT_MAP * 1.
 #define MAP_MANIFOLD    PLOT_MAP * 2.
 #define MAP_CONTOUR    PLOT_MAP * .25
 #define PLOT_RAYS   1.
 #define RAY_POSITION   PLOT_RAYS * 2.
 #define RAY_PATH   PLOT_RAYS * 1.
 #define RAY_DISTANCE   PLOT_RAYS * 1.
 #define RAY_ANIMATE   (mouse.x < .75 ? floor(fract(time/16.) * 24.) : 32.)
 #define RAYS     1
 #define ITERATIONS    16
 #define THRESHOLD   .01
 #define FARPLANE    4.
 #define SCALE    .5
 #define ORTHOGRAPHIC   false
 #define FOV    1.25
 #define VIEWPOINT   vec2(-1.75, 0.)
 #define VIEWTARGET   (mouse.x < .75 ? vec2(1., 0.) : vec2(.5, mouse.y-.5)*8.)
 #define LIGHT_POSITION   vec2(-.5, .95)
 #define LIGHT_COLOR   vec3(.75, .75, .45)
 #define OCCLUSION_ITERATIONS  0
 #define SHADOW_ITERATIONS  0
#endif

//calculating derivatives
#ifdef SLIDE_DERIVE_NORMALS
 #define SCENE_SPHERES
 #define PLOT_MAP   1.
 #define MAP_DISTANCE    PLOT_MAP * 1.
 #define MAP_MANIFOLD    PLOT_MAP * 2.
 #define MAP_CONTOUR    PLOT_MAP * .25
 #define PLOT_RAYS   .125
 #define RAY_POSITION   PLOT_RAYS * 2.
 #define RAY_PATH   PLOT_RAYS * 1.
 #define RAY_DISTANCE   PLOT_RAYS * 1.
 #define PLOT_DERIVATIVE   1.
 #define DERIVATIVE_LINE_SCALE  .25
 #define DERIVATIVE_NORMAL  PLOT_DERIVATIVE * vec3(0., 1., 0.)
 #define DERIVATIVE_TANGENT  PLOT_DERIVATIVE * vec3(1., 0., 0.)
 #define DERIVATIVE_SAMPLE  PLOT_DERIVATIVE * 1.
 #define DERIVATIVE_SAMPLE_SCALE  .125
 #define DERIVATIVE_ANIMATE  floor(fract(time/16.) * 16.)
 #define RAYS     1
 #define ITERATIONS    16
 #define THRESHOLD   .01
 #define FARPLANE    4.
 #define SCALE    .5
 #define ORTHOGRAPHIC   false
 #define FOV    1.25
 #define VIEWPOINT   vec2(-1.75, 0.)
 #define VIEWTARGET   vec2(1., 0.)
 #define LIGHT_POSITION   vec2(-.5, .95)
 #define LIGHT_COLOR   vec3(.75, .75, .45)
 #define OCCLUSION_ITERATIONS  0
 #define SHADOW_ITERATIONS  0
#endif

#ifdef SLIDE_LIGHTS_AND_MATERIALS
 #define SCENE_RED_BALL_ON_CHECKER_FLOOR
 #define PLOT_MAP   1.
 #define MAP_DISTANCE    PLOT_MAP * 2.
 #define MAP_MANIFOLD    PLOT_MAP * 1.
 #define MAP_CONTOUR    PLOT_MAP * .125
 #define PLOT_LIGHT   1.
 #define LIGHT_OCCLUSION   PLOT_LIGHT * 1.
 #define LIGHT_SHADOW   PLOT_LIGHT * 1.
 #define LIGHT_BRDF   PLOT_LIGHT * 1.
 #define LIGHT_RAY   PLOT_LIGHT * 1.
 #define LIGHT_SHADE   PLOT_LIGHT * 1. 
 #define RAYS     12
 #define RAY_REFINEMENT
 #define ITERATIONS    32
 #define THRESHOLD   .005
 #define FARPLANE    4.
 #define SCALE    .5
 #define FOV    (mouse.y < .9 ? max(1.,length(VIEWTARGET- VIEWPOINT)*4.5) : 3.)
 #define ORTHOGRAPHIC   false
 #define VIEWPOINT   vec2(-1.5, 0.)
 #define VIEWTARGET   (mouse.y < .9 ? ((mouse * 2. - 1.) *  ASPECT) : vec2(1., 0.))
 #define LIGHT_POSITION   vec2(-.5, .95)
 #define LIGHT_COLOR   vec3(.75, .75, .45)
 #define OCCLUSION_ITERATIONS  3
 #define SHADOW_ITERATIONS  6  
 #define REFLECTION true
 #define REFRACTION true
#endif 


#define RESOLUTION_MIN    min(resolution.x, resolution.y)
#define RESOLUTION_MAX    min(resolution.x, resolution.y)
#define LINE_RESOLUTION    (256.)
#define ASPECT     resolution.xy/RESOLUTION_MIN
#define PI     (4. * atan(1.))
#define TAU     (8. * atan(1.))


struct ray
{
 vec2  origin;
 vec2  position;
 vec2  prior;
   vec2  direction;
   float range;
 float travel;
   float iteration;
 float threshold;
   bool  intersection;
};

struct material
{
   float id;
   float index;
   float roughness;
 float opacity;
   vec2 uv;
   vec2 normal;
   vec2 tangent;
   vec3 color;
};  

struct light
{
   vec2 position;
   vec2 direction;
   vec3 color;
};


struct plot
{
 vec2 prior;
 vec2 position;
 vec2 point;
   vec3 ray;
  vec3 light;
 vec3 color;
 vec3 derivative;
 vec3 brdf;
   vec3 occlusion;
   vec3 shadow;
 vec3 map;
};

ray  construct_ray(void);
material construct_material(void);
light  construct_light(void);
plot  construct_plot(const in vec2 position);

float   map(vec2 p);
void   map(in vec2 p, out float range, out float id);
void   intersect(const in float range, const in float id, inout float minimum, inout float material_id);

void   view(in float index, inout ray r);
void   emit(inout ray r, inout plot p);
void  derive(inout ray r, inout material m, inout plot p);
void   shade(inout ray r,  inout light l, inout material m, inout plot p);

float   shadow(const in vec2 position, const in vec2 direction, inout ray r, inout plot p);
float   distribution(const in float r, const in float ndh);
float   geometry(in float i, in float ndl, in float ndv);
float   fresnel(const in float i, const in float ndl);

void   assign_material(in ray r, out material m);

void   plot_ray(in vec2 position, inout ray r, inout plot p);

float   contour(float x);
float   point(vec2 position, float radius);
float   point(vec2 position);
float   circle(vec2 position, float radius);
float   line(vec2 p, vec2 a, vec2 b);
float   box(vec2 position, vec2 scale);

float   hash(in float x );
float   hash(in vec2 x );
float   value_noise(vec2 uv);
float   fbm(vec2 uv);

vec3   hsv(float h, float s,float v);

float   face(vec2 position, vec2 normal, float translation);
float   sphere(vec2 position, float radius);
float   torus(vec2 position, vec2 radius);
float   cube(vec2 position, vec2 scale);
float   simplex(vec2 position, float scale);
float   fractal(vec2 position, float rotation, float translation, float scale);
float   segment(vec2 position, vec2 a, vec2 b);

vec2   cross(in vec2 uv);
vec2   project(vec2 position, vec2 a, vec2 b);
mat2   rmat(in float t);

#//Scene Map
void map(in vec2 position, out float range, out float id)
{
 vec2 mouse_position = (mouse * 2. - 1.) * resolution.xy/resolution.yy;
 
 range   = FARPLANE;
 id   = 0.;

 #ifdef SCENE_PYTHAGORAS
 float material_id = 5.;
 
 
 float fields[7];
 fields[0]  = sphere(position-vec2(.75, 0.), .0);
 fields[1]  = min(fields[0], sphere(position+vec2(.75, 0.), .0));
 fields[2]  = cube(position, vec2(.5));
 fields[3]  = simplex(position, .5);
 fields[4]  = torus(position, vec2(.35, .125));
 fields[5]  = segment(position, vec2(0.), vec2(.71, 0.) * rmat(time))-.015;
 fields[6]  = fractal(position, cos(time*.25)*.5+1., .3, .15);
 
 float field  = 0.;
 float selection  = floor(mouse.x * 7.);
 for(int i = 0; i < 7; i++)
 {
  if(selection == float(i))
  {
   intersect(fields[i], material_id, range, id);
  }
 }
 #endif 
 
 
 #ifdef SCENE_DISTANCE_FUNCTIONS
 float material_id = 5.;
 float fields[7];
 fields[0]  = face(position, vec2(0., 1.), 1.-mouse.y*2.);
 fields[1]  = sphere(position, .5);
 fields[2]  = cube(position, vec2(.5));
 fields[3]  = simplex(position, .5);
 fields[4]  = torus(position, vec2(.35, .125));
 fields[5]  = segment(position, vec2(0.), vec2(.71, 0.) * rmat(time))-.015;
 fields[6]  = fractal(position, cos(time*.25)*.5+1., .3, .15);
 
 float field  = 0.;
 float selection  = floor(mouse.x * 7.);
 for(int i = 0; i < 7; i++)
 {
  if(selection == float(i))
  {
   intersect(fields[i], material_id, range, id);
  }
 }
 #endif 
 
 #ifdef SCENE_DISTANCE_OPERATIONS
 float material_id = 5.;
 vec2 offset  = vec2(.5, 0.) * cos(time*.3);
 float s   = sphere(position-offset-vec2(.25, 0.), .5);
 float c    = cube(position+offset+vec2(.25, 0.), vec2(.5));
 float n    = fbm((position*.5)*2.+322.)*.75 * min(mouse.y, .75);
 float fields[7];
 fields[0]  = min(s, c);
 fields[1]  = max(-s, c);
 fields[2]  = max(-max(c, s), min(c, s));
 fields[3]  = max(max(c, s), min(c, s));;
 fields[4]  = sphere(mod(position + time * .125, 1.)-.5, .25);
 fields[5]  = cube(position * (1.+n*2.), vec2(.75));
 fields[6]  = max(-face(position, vec2(0., 1.), .7), fractal((position+vec2(0.,.7)+n*n), .23-n*.15, .3+n*.3, .4-n*.5-position.y*.125));
 
 float field  = 0.;
 float selection  = floor(mouse.x * 7.);
 for(int i = 0; i < 7; i++)
 {
  if(selection == float(i))
  {
   intersect(fields[i], material_id, range, id);
  }
 }
 #endif 
 
 #ifdef SCENE_FANCY_EXAMPLE
 
 #endif
 
 
 //demo spheres
 #ifdef SCENE_SPHERES
 float material_id = 5.;
 intersect(sphere(position + vec2(0.5,    .35), .25), material_id, range, id);
 intersect(sphere(position + vec2(-.1,   -.25), .15), material_id, range, id);
 intersect(sphere(position + vec2(-1.35, 0.35), .55), material_id, range, id);
 intersect(sphere(position + vec2(-1.45, -.25), .25), material_id, range, id);
 #endif 
 
 #ifdef SCENE_RED_BALL_ON_CHECKER_FLOOR
 intersect(face(position, vec2(0.,1.), .75), 1., range, id);
 intersect(sphere(position + vec2(-.75, 0.), .75), 2., range, id);
 intersect(face(position, vec2(-1.,0.), 2.5), 1., range, id);
 #endif
}


#//Materials
void assign_material(in ray r, out material m)
{
 map(r.position, r.range, m.id);
 
 if(m.id == 1.)
 {
  m.roughness  = .2;
  m.index  = .5;
  m.opacity = 1.;
  bool checker = fract(2. * r.position.x) < .5;
  m.color   = checker ? vec3(.25) : vec3(.125);
 }
 else if(m.id == 2.)
 {
  m.roughness  = .1;
  m.index  = .6;
  m.opacity = .75;
  m.color  = vec3(.75, .25, .125);
 }
 else if(m.id == 3.)
 {
  m.roughness  = .1;
  m.index  = .8;
  m.opacity = .025;
  m.color  = vec3(.55, .75, .95);
 }
 else if(m.id == 4.)
 {
  m.roughness  = .5;
  m.index  = .5;
  m.opacity = .5;
  m.color  = vec3(1., 1., 1.);
 }
 else if(m.id == 5.)
 {
  m.roughness  = .5;
  m.index  = .5;
  m.opacity = .5;
  m.color  = vec3(0., 1.5, 0.);
 }
 else
 {
  m.id  = 0.;
  m.roughness  = 1.;
  m.index  = 1.;
  m.color  = vec3(1.);
 }
}

#ifdef RAY_ANIMATE
float ray_steps = 0.;
#endif

vec3 pythagoras_slide(vec2 position)
{
 return vec3(0.); 
}

void main( void ) 
{
 vec2 uv   = gl_FragCoord.xy/resolution.xy;
 vec2 position = (uv * 2. - 1.) * ASPECT;
 vec2 mouse = (mouse * 2. - 1.) * ASPECT;
 
 plot p  = construct_plot(position);
 
 for(int i = 1; i <= RAYS; i++)
 {
  #ifdef RAY_ANIMATE
  ray_steps = 0.;
  #endif
  
  ray r  = construct_ray();
  
  view(float(i), r);
  
  #ifdef PLOT_RAYS
  p.color  = max(p.color, circle(p.position-r.origin,.01) * .25);
  #endif 
  
  emit(r, p);
  
  if(r.intersection)
  {
   #ifdef RAY_REFINEMENT
   p.ray.x   += circle(position-r.position,THRESHOLD);
   #endif
   
   material m  = construct_material();
   
   assign_material(r, m);
 
   derive(r, m, p);

   r.position  -= m.normal * abs(r.range-THRESHOLD);

   #ifdef RAY_REFINEMENT
   p.ray.x   += circle(position-r.position,.05);   
   #endif
   
   light l   = construct_light(); 
   l.position  = LIGHT_POSITION;
   l.direction  = normalize(l.position-r.position);
   
   p.point   = l.position;
   
   #ifdef REFLECTION
   ray r2    = construct_ray();
   material m2   = m;
   r2.threshold  = 0.;
   r2.direction   = reflect(r.direction, m2.normal);
   r2.origin  = r.position + r2.direction * .025;
   r2.position  = r2.origin;
   
   emit(r2, p);
   
   assign_material(r2, m2);
 
   derive(r2, m2, p);
   
   if(r2.intersection)
   {
    #ifdef RAY_REFINEMENT
    p.ray.y  += circle(position-r2.position,THRESHOLD);   
    #endif
   
    r2.position += m2.normal * abs(r2.range-THRESHOLD);
    
    #ifdef RAY_REFINEMENT
    p.ray.y  += circle(position-r2.position,THRESHOLD);   
    #endif
    
    p.point  = r.position;
    light l2  = l;
    l2.direction  = normalize(l2.position-r2.position);
    l2.color  = LIGHT_COLOR * m.color;

    shade(r2, l2, m2, p);
   }
   #endif
  

   #ifdef REFRACTION
   if(m.opacity < 1.)
   {
    ray r3   = r;
    r3.intersection = false;
    
    material m3  = m;
    r3.direction  = refract(m3.normal, r3.direction, m.index);
    r3.origin = r3.position - r3.direction  * .0125;
    r3.position = r3.origin;
    r3.travel = 0.;

    #ifdef RAY_REFINEMENT
    p.ray.z  += circle(position-r3.position,THRESHOLD);   
    #endif
    
    emit(r3, p);
   
    if(r3.intersection)
    {
     derive(r3, m3, p);
    
     #ifdef RAY_REFINEMENT
     r3.position += m3.normal * abs(r3.range-THRESHOLD);
     p.ray.z  += circle(position-r3.position,THRESHOLD);   
     #endif
    
     light l2  = l;
     l2.position  = r.position;
     l2.direction  = refract(m3.normal, l2.direction, m.index);
     l2.color  = mix(LIGHT_COLOR, m3.color, m3.opacity);
  
     p.point  = l2.position;  
     shade(r3, l2, m3, p);
    

     r3.direction  = refract(m3.normal, r3.direction, 1.);  
     r3.origin = r3.position + r3.direction * THRESHOLD;  
     r3.position = r3.origin;
     r3.travel = 0.;
  
     r3.intersection = true;
    
    
     #ifdef RAY_REFINEMENT
     p.ray.z  += circle(position-r3.position,.05);   
     #endif
     
     p.point  = r3.position;
     emit(r3, p);
     
     derive(r3, m3, p);
     l2.position  = r3.origin;
     l2.direction  = refract(m3.normal, l2.direction, m.index); 
     l2.color  = mix(l2.color, m3.color, m3.opacity);
       
     shade(r3, l2, m3, p);
    }
   }
   #endif
  
  
   #ifdef REFLECTION
   m.color  = mix(m.color, m2.color, m.roughness);
   #endif
   
   l.position  = LIGHT_POSITION;
   l.color   = LIGHT_COLOR;
   l.direction  = normalize(l.position-r.position);
   p.point  = l.position;  
   shade(r, l, m, p);
   
   #ifdef RAY_ANIMATE
   if(ray_steps > 32.) break;
   #endif
  }  
 }
 
 
 #ifdef PLOT_MAP
 float scene = map(position); 
 ray r  = construct_ray();
 r.position = position-r.origin;
 r.intersection = true;

 material m = construct_material(); 
 
 assign_material(r, m);
 
 m.color  = scene < THRESHOLD ? m.color : vec3(scene*.25);

  #ifdef MAP_DISTANCE
  p.map  += abs(scene) * m.color * MAP_DISTANCE;
  #endif
 
  #ifdef MAP_MANIFOLD
  p.map  += contour(abs(scene)) * m.color * MAP_MANIFOLD;   
  #endif

  #ifdef MAP_CONTOUR
  p.map  += contour(abs(.01+fract(scene*16.-.5)-.5)/16.) * MAP_CONTOUR;
  #endif
 #endif
 
 #ifdef PLOT_LIGHT
 p.light  =  max(p.light,  point(position-LIGHT_POSITION,  5.) * LIGHT_COLOR);
 p.light  += max(p.light, circle(position-LIGHT_POSITION, .02)) * .0625;
 #endif 
 
 vec4 result  = vec4(0.);
 result.xyz += p.ray;
 result.xyz += p.derivative;
 result.xyz += p.brdf;
 result.xyz += p.light;
 result.xyz += p.color;
 result.xyz += p.map;
 result.xyz += p.occlusion;
 result.xyz += p.shadow;
 
 #ifdef SLIDE_PYTHAGORAS
 float grid = 0.;
 grid  = max(contour(abs(.01+fract(position.x*16.-.5)-.5)/16.) * MAP_CONTOUR, contour(abs(.01+fract(position.y*16.-.5)-.5)/16.) * MAP_CONTOUR);
 
 result   *= 0.;
 result.xyz += grid;
 result   = clamp(1.-result, 0., 1.);
 
 vec2 point_origin = vec2(0., 0.);
 vec2 point_position = point_origin;
 vec2 mouse_position = mouse;

 float target_point = point(position-point_origin, 8.);
 float mouse_point = point(position-mouse_position, 8.);
 
 
 float x  = 0.;
 float y  = 0.;
 float z  = 0.;
 float x_box = 0.;
 float y_box = 0.;
 float z_box = 0.;
 
 bvec2 maxima = bvec2(mouse_position.x < point_position.x, mouse_position.y < point_position.y);
 float width = abs(point_position.x-mouse_position.x) * (maxima.y ? 1. : -1.);
 float height = abs(point_position.y-mouse_position.y) * (maxima.x ? 1. : -1.);
 
 vec2 offset = vec2(0.);
 offset.x  = maxima.x ? width : 0.;
 
 float diagonal = length(mouse_position-point_position);
 
 vec2 direction = cross(normalize(point_position-mouse_position));
 direction.x *= maxima.x ^^ maxima.y ? 1. : -1.;
 direction.y *= maxima.x ^^ maxima.y ? 1. : -1.;
 
 vec2 v[4];
 v[0]  = mouse_position;
 v[1]  = vec2(mouse_position.x, point_position.y);
 v[2]  = vec2(point_position.x, mouse_position.y);
 v[3]  = point_position;
 
  
 //xbox
 x   += line(position, v[1], v[3]); 
 x_box   += line(position, v[0]-vec2(height, 0.), v[1]-vec2(height, 0.)); 
 x_box   += line(position, v[0]-vec2(height, 0.), v[0]); 
 x_box   += line(position, v[1], v[1]-vec2(height, 0.)); 
 
 //ybox
 y   += line(position, v[0], v[1]); 
 y_box   += line(position, v[3], v[3]+vec2(0., width)); 
 y_box   += line(position, v[1], v[1]+vec2(0., width)); 
 y_box   += line(position, v[1]+vec2(0., width), v[3]+vec2(0., width)); 
 
 //zbox
 z   += line(position, v[0], v[3]);
 z_box   += line(position, v[0], v[0] + direction * diagonal); 
 z_box   += line(position, v[3], v[3] + direction * diagonal); 
 z_box   += line(position, v[0] + direction * diagonal, v[3] + direction * diagonal);
 
 float mouse_circle = circle(position-mouse_position, diagonal);
 float point_circle = circle(position-point_position, diagonal);
 
 
 float p_rings = contour(abs(.01+fract(length(position-point_position)*16.-.5)-.5)/16.) * MAP_CONTOUR;
 float m_rings = contour(abs(.01+fract(length(position-mouse_position)*16.-.5)-.5)/16.) * MAP_CONTOUR;

 
 float frame = mod(floor(time*2.5), 16.);
 result  -= frame > 0. ? target_point : 0.;
 result  -= frame > 1. ? mouse_point : 0.;
 result.yz -= frame > 2. ? x  : 0.;
 result.xz -= frame > 3. ? y  : 0.;
 result.xy -= frame > 4. ? z  : 0.;
 
 result.yz -= frame > 5. ? y_box  : 0.;
  result.xz -= frame > 6. ? x_box  : 0.;

 result.xy -= frame > 7. ? z_box  : 0.;
 result  -= frame > 8. ? point_circle : 0.;
 result  -= frame > 9. ? mouse_circle : 0.;

// result   -= p_rings+m_rings;
 #endif
 
 gl_FragColor  = result;
 gl_FragColor.w = 1.;
}//sphinx


#//Rays
void view(float index, inout ray r)
{
 float rays = float(RAYS);
 float ray_angle = index - rays * .5 - .5;
 r.direction     = normalize(VIEWTARGET-VIEWPOINT);
  
 r.direction  *= rmat(ray_angle/TAU/FOV);
 r.origin  = VIEWPOINT + r.direction * .125 * SCALE;
  
 #ifdef ORTHOGRAPHIC
 if(ORTHOGRAPHIC)
 {
  r.direction     = normalize(VIEWTARGET-VIEWPOINT);
  r.origin  = VIEWPOINT - ray_angle * (SCALE)/rays * VIEWPOINT * rmat(atan(r.direction.x, r.direction.y));
 }
 #endif
  
 r.position  = r.origin; 
}


void emit(inout ray r, inout plot p)
{
 r.prior     = r.origin;
 r.threshold   = THRESHOLD;
 
 float travel   = 0.;
 float parity  = map(r.position) < 0. ? -1. : 1.;
 
 r.intersection  = false;
 
 for(int i = 1; i <= ITERATIONS; i++)
 {
  #ifdef RAY_ANIMATE
  ray_steps++;
  if(ray_steps >= RAY_ANIMATE) return;
  #endif
  
  r.iteration++;
  
  r.prior    = r.position;
  
  r.range  = map(r.position) * parity;
   
  r.travel  += r.range;
   
  r.position  = r.origin + r.direction * r.travel * parity; 
  
  r.range   = r.range <= 0. ? r.range - r.range * .5 : r.range;
  
  #ifdef PLOT_RAYS
   float plots = 0.;
 
   #ifdef RAY_POSITION
   plots   += RAY_POSITION * point(p.position-r.position);
   #endif
 
   #ifdef RAY_PATH 
   plots  += RAY_PATH * line(p.position, r.prior, r.position);
   #endif
 
   #ifdef RAY_DISTANCE
   plots  += RAY_DISTANCE * circle(p.position-r.prior, r.range);
   #endif
  
   vec3 hue  = hsv(.65-float(r.iteration)/float(ITERATIONS), 1., 1.);
  
   p.ray   = max(p.ray, hue * clamp(plots, 0., 1.));
  #endif
  
  if(r.range < r.threshold && i > 3)
  { 
   r.intersection = true;
   return;
  }
  
  
 }
 
 r.range   = r.travel;
 r.travel  = FARPLANE;
}


void derive(inout ray r, inout material m, inout plot p)
{
 
 float offset = .125;
 
 vec4 sample = vec4(0.);
 float right = map(r.position+vec2(offset, 0.));
 float left = map(r.position-vec2(offset, 0.));
 float up  = map(r.position+vec2(0., offset));
 float down = map(r.position-vec2(0., offset));
 
 m.normal  = vec2(right - left, up - down) * 4.;
 m.normal  = normalize(m.normal);
     m.tangent = cross(m.normal);
 
 #ifdef PLOT_DERIVATIVE
 if(r.intersection)
 {
  float anim = 8.;

  #ifdef DERIVATIVE_SAMPLE
  vec2 position  = p.position-r.position;
  vec2 tint  = vec2(.5, 1.); 
 
  p.derivative.xyz  += point(position);
  
  right  = abs(right);
  left  = abs(left);
  up  = abs(up);
  down  = abs(down);
  
  #ifdef DERIVATIVE_ANIMATE
  anim   = DERIVATIVE_ANIMATE;  
  #endif 
  

  p.derivative.yz += anim > 0. ? point(position + vec2(offset, 0.)) * tint : vec2(0.);
  p.derivative.x += anim > 1. ? point(position - vec2(offset, 0.)) : 0.;
  p.derivative.xy += anim > 2. ? point(position + vec2(0., offset)) : 0.;
  p.derivative.y += anim > 3. ? point(position - vec2(0., offset)) : 0.;
  
  p.derivative.yz += anim > 0. ? line(p.position, r.position, r.position - vec2(offset, 0.)) * tint : vec2(0.);;
  p.derivative.x += anim > 1. ? line(p.position, r.position, r.position + vec2(offset, 0.)) : 0.;;
  p.derivative.xy += anim > 2. ? line(p.position, r.position, r.position - vec2(0., offset)) : 0.;;
  p.derivative.y += anim > 3. ? line(p.position, r.position, r.position + vec2(0., offset)) : 0.;;
  
  p.derivative.yz += anim > 0. ? circle(position + vec2(offset, 0.),  left) * DERIVATIVE_SAMPLE * tint : vec2(0.);
  p.derivative.x += anim > 1. ? circle(position - vec2(offset, 0.), right) * DERIVATIVE_SAMPLE : 0.;
  p.derivative.xy += anim > 2. ? circle(position + vec2(0., offset),  down) * DERIVATIVE_SAMPLE : 0.;
  p.derivative.y += anim > 3. ? circle(position - vec2(0., offset),    up) * DERIVATIVE_SAMPLE : 0.;
  #endif
  

  #ifdef DERIVATIVE_ANIMATE 
  /* //aabb
  float hor = (right+left);
  float vert = (up+down);

  p.derivative.yz += line(p.position, r.position, r.position - vec2(hor, 0.))*tint;
  p.derivative.x  += line(p.position, r.position, r.position + vec2(hor, 0.));
  p.derivative.xy += line(p.position, r.position, r.position - vec2(0., vert));
  p.derivative.y  += line(p.position, r.position, r.position + vec2(0., vert));


  p.derivative.xyz  += line(p.position, r.position + vec2(hor, vert), r.position + vec2(-hor, vert));
  p.derivative.xyz  += line(p.position, r.position - vec2(hor, vert), r.position - vec2(-hor, vert));
  p.derivative.xyz  += line(p.position, r.position + vec2(hor, vert), r.position + vec2(hor, -vert));
  p.derivative.xyz  += line(p.position, r.position - vec2(hor, vert), r.position - vec2(hor, -vert));
  */
  #else 
  anim   = 1.;
  #endif
 
  #ifdef DERIVATIVE_NORMAL
  p.derivative += anim > 4. ? line(p.position, r.position, r.position + m.normal * DERIVATIVE_LINE_SCALE) *  DERIVATIVE_NORMAL * anim : vec3(0.);
  p.derivative += anim > 4. ? point(position - m.normal * DERIVATIVE_LINE_SCALE) * DERIVATIVE_NORMAL * anim : vec3(0.);
  #endif
 
  #ifdef DERIVATIVE_TANGENT
  p.derivative += anim > 5. ? line(p.position, r.position, r.position + m.tangent * DERIVATIVE_LINE_SCALE) * DERIVATIVE_TANGENT * anim : vec3(0.);
  p.derivative += anim > 5. ? point(position - m.tangent * DERIVATIVE_LINE_SCALE) * DERIVATIVE_TANGENT * anim : vec3(0.);
  #endif
 }
 #endif
}


#//Material Intersection
void intersect(const in float range, const in float id, inout float minimum, inout float material_id)
{
 material_id  = range < minimum ? id : material_id;
 minimum  = min(minimum, range);
}

float map(vec2 position)
{
 float id  = 0.;
 float range  = FARPLANE;
 
 map(position, range, id);
 
 return range;
}


#//Shading
float fresnel(const in float i, const in float ndl)
{   
 return i + (1.-i) * pow(1.-ndl, 5.0);
}


float geometry(in float i, in float ndl, in float ndv)
{
 ndl             = max(ndl, 0.);
 ndv             = max(ndv, 0.);
 float k         = i * sqrt(2./PI);
 float ik        = 1. - k;
 return (ndl / (ndl * ik + k)) * ( ndv / (ndv * ik + k) );
}


float distribution(const in float r, const in float ndh)
{  
 float m     = 2./(r*r) - 1.;
 return (m+r)*pow(ndh, m)*.5;
}


float shadow(const in vec2 position, const in vec2 direction, inout ray r, inout plot p)
{
 float exposure  = 1.0;
 float penumbra  = .1;
 float umbra = length(r.position-LIGHT_POSITION);
 
     for(int i = 0; i < SHADOW_ITERATIONS; ++i)
     {
  float range = map(position + direction * penumbra);

  #ifdef LIGHT_SHADOW
  p.shadow += circle(p.position - position - direction * penumbra - direction * .015, range) * .5;
  #endif
  
  exposure  = min(exposure, 3. * range / penumbra);
  penumbra  += range;
 }
 #ifdef LIGHT_SHADOW
 p.shadow = max(vec3(.1)*p.shadow, p.shadow * exposure * LIGHT_COLOR);
 #endif
  
 return exposure;
}


float occlusion(in vec2 position, in vec2 normal, inout ray r, inout plot p)
{
   float occlusion  = 1.;
   float penumbra   = .05;
 float max_range  = .5;
 
 #ifdef LIGHT_OCCLUSION
 float rings = 0.;
 #endif
 
   for (int i=0; i < OCCLUSION_ITERATIONS; i++ )
   {
    float radius  = .5 * penumbra * float(i);
      float range  = map(position + normal * radius);
  
  if(range < max_range)
  {
   #ifdef LIGHT_OCCLUSION
   rings  += circle(p.position - position - normal * radius, range);
   #endif
   
   occlusion  -= penumbra * range;
  }
  else
  {
   break;
  } 
   }
 
 #ifdef LIGHT_OCCLUSION
 rings   = clamp(rings, 0., 1.);
 p.occlusion = max(p.occlusion, rings*.75);
 #endif 
 
   return occlusion;
}


void shade(inout ray r,  inout light l, inout material m, inout plot p)
{
 vec2 half_direction  = normalize(r.direction - l.direction);
 float half_normal    = dot(half_direction, m.normal);
 
 if(r.intersection)
 {
  //exposure coefficients
  float light_exposure     = dot(m.normal,  l.direction);   
  float view_exposure      = dot(m.normal, -r.direction);  
  
  
  //microfacet lighting components
  float d               = distribution(m.roughness, half_normal);
  float g               = geometry(m.roughness, light_exposure, view_exposure);
  float f               = fresnel(m.index, view_exposure);
  float n               = clamp(1. - fresnel(f, light_exposure), 0., 1.);
  
  vec3 fog   = vec3(.65, .65, .8);

 
  //bidrectional reflective distribution function
  float brdf               = (g*d*f)/(view_exposure*light_exposure*4.);  
  
  vec3 color   = m.color * fog + m.color * l.color * n + brdf * l.color;
  
    
  float shadows   = shadow(r.position, l.direction, r, p);
  shadows    = clamp(shadows, .0, 1.);

  float occlusions  = occlusion(r.position, m.normal, r, p);
  occlusions   = clamp(occlusions, .0, 1.);

  color     *= occlusions * shadows;
  
  color    = mix(color, fog, r.travel/FARPLANE/8.);
  
  #define BRDF_SCALE  .05
  
  #ifdef PLOT_LIGHT
  vec2 h_position   = r.position + half_direction * BRDF_SCALE * (.5 * brdf);
  vec2 brdf_cone   = m.tangent * m.roughness * BRDF_SCALE;
  vec3 light_color   = max(l.color, vec3(.05)) * shadows * occlusions;
  vec3 surface_color  = max(color, vec3(.05));
  
   #ifdef LIGHT_BRDF
   vec3 brdf_plot   = vec3(0.);
   
   vec4 term   = normalize(vec4(d,g,f,-n)) * .25;
  
   vec2 t_position   = r.position + half_direction;
   brdf_plot.x   += line(p.position,  r.position, r.position + half_direction * term.x);
   brdf_plot.x   += point(p.position - r.position - half_direction * term.x);
   
   brdf_plot.y   += line(p.position,  r.position, r.position + half_direction * term.y);
   brdf_plot.y   += point(p.position - r.position - half_direction * term.y);
   
   brdf_plot.z   += line(p.position,  r.position, r.position + half_direction * term.z);
   brdf_plot.z   += point(p.position - r.position - half_direction * term.z);
  
   brdf_plot.xy   += line(p.position,  r.position, r.position + half_direction * term.w);
   brdf_plot.xy   += point(p.position - r.position - half_direction * term.w);
   
   p.brdf    = max(p.brdf, brdf_plot * LIGHT_BRDF);
   #endif
  
   #ifdef LIGHT_RAY
   vec3 light_plot   = vec3(0.);
   
   //light to intersection
   light_plot   += line(p.position, p.point, r.position - brdf_cone) * light_color;
   light_plot   += line(p.position, p.point, r.position + brdf_cone) * light_color;
 
   //intersection to origin
   light_plot   += line(p.position, r.origin, r.position - brdf_cone) * surface_color;
   light_plot   += line(p.position, r.origin, r.position + brdf_cone) * surface_color;
   light_plot   += line(p.position, r.position + brdf_cone, r.position - brdf_cone) * surface_color;
 
   light_plot   += line(p.position,  h_position, r.position - brdf_cone) * surface_color;
   light_plot   += line(p.position,  h_position, r.position + brdf_cone) * surface_color;
   light_plot   += point(p.position - h_position) * surface_color;
  
   p.light    = max(p.light, light_plot * LIGHT_RAY);
   #endif
  
   #ifdef LIGHT_SHADE
   float scene   = map(p.position);  
   float contour   = 1.-clamp(abs(scene) * LINE_RESOLUTION * .25, 0., 1.);
   float spot   = clamp(.5-length(p.position-r.position) - .125, 0., 1.);
   p.color    = max(p.color, spot * color * contour * LIGHT_SHADE);
   p.color    = max(p.color, point(p.position-r.origin) * surface_color);
   #endif
  
   #ifdef LIGHT_OCCLUSION
   p.occlusion  = p.occlusion*fog;
   #endif 
  
   #ifdef LIGHT_SHADOW
   p.shadow  = mix(fog * p.shadow, p.shadow, fog);
   #endif
  #endif
  
  m.color = color;
 }
}

#//Lines
float contour(float x)
{
 return 1.-clamp(x * LINE_RESOLUTION, 0., 1.);
}

float point(vec2 position, float radius)
{
 return contour(sphere(position, radius/RESOLUTION_MIN)); 
}

float point(vec2 position)
{
 return point(position, 4.); 
}

float circle(vec2 position, float radius)
{
 return contour(torus(position, vec2(radius,0.)));
}

float line(vec2 p, vec2 a, vec2 b)
{
 return contour(segment(p, a, b));
}

float box(vec2 position, vec2 scale)
{
 return contour(abs(cube(position, scale))); 
}

vec3 hsv(float h,float s,float v)
{
 return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}


#//Distance Fields
float face(vec2 position, vec2 normal, float translation)
{
  return dot(position, normal) + translation;
}


float sphere(vec2 position, float radius)
{
 return length(position)-radius;
}


float torus(vec2 position, vec2 radius)
{
 
 return abs(abs(length(position)-radius.x)-radius.y);
}


float cube(vec2 position, vec2 scale)
{
 vec2 vertex  = abs(position) - scale;
 vec2 edge  = max(vertex, 0.);
 float interior = max(vertex.x, vertex.y);
 return min(interior, 0.) + length(edge);
}


float simplex(vec2 position, float scale)
{  
 position.y *= 0.57735026918 ; //1./sqrt(3.); 
 vec3 edge = vec3(0.);
 edge.x  = position.y + position.x;
 edge.y  = position.x - position.y;
 edge.z  = position.y + position.y;
 edge  *= .86602540358; //sqrt(3.)/2.

 return max(edge.x, max(-edge.y, -edge.z))-scale*.57735026918;
}


float fractal(vec2 position, float rotation, float translation, float scale)
{
 const int iterations  = 8;
 
 float radius   = 1.5/float(iterations); 
 
 rotation   = rotation * TAU + TAU * .5;
 
 position   = abs(position);   
 position.y  -= radius;
 scale    *= radius;
 float result   = max(position.x, position.y) - scale;
        for (int i = 0; i < iterations; i++)
 {   
  float magnitude = length(position);
  
  float phase  = atan(position.x, position.y);
  phase   = mod(phase, rotation) - rotation * .5; 
  
  position.x  = magnitude * cos(phase);
  position.y  = magnitude * sin(phase);
 
  position  = abs(position);  
  
  position.y -= translation;
  
  translation *= .7;
  scale  *= .8;
  rotation *= -.98;
  
  result   = min(max(position.x, position.y) - scale, result);
 }
 
 return result;
}

float segment(vec2 position, vec2 a, vec2 b)
{
 return distance(position, project(position, a, b));
}


#//Matrices
mat2 rmat(in float t)
{
 float c = cos(t);
 float s = sin(t);   
 return mat2(c,s,-s,c);
}

#//White Noise
float hash(in float v )
{
    return fract(sin(v)*12345.6789);
}


float hash(in vec2 uv) 
{ 
    return fract(sin(+uv.y*512.*cos(uv.x)+uv.x)*12345.6789); 
}


float value_noise(vec2 uv)
{
 const float k   = 257.;
 vec4 l    = vec4(floor(uv),fract(uv));
 float u   = l.x + l.y * k;
 vec4 v    = vec4(u, u+1.,u+k, u+k+1.);
 v         = fract(fract(v*1.23456789)*9.18273645*v);
 l.zw      = l.zw*l.zw*(3.-2.*l.zw);
 l.x       = mix(v.x, v.y, l.z);
 l.y       = mix(v.z, v.w, l.z);
 return mix(l.x, l.y, l.w);
}


#//Pink Noise
float fbm(vec2 uv)
{
 float a = .5;
 float f = 2.;
 float n = 0.;
 const int octaves = 6;
 for(int i = 0; i < octaves; i++)
 {
  n += value_noise(uv * f) * a;
  f *= 2.;
  a *= .5;
 }
 return n;
}


#//Projection
vec2 cross(in vec2 uv)
{
 return vec2(-uv.y, uv.x);
}

vec2 project(vec2 position, vec2 a, vec2 b)
{
 vec2 q   = b - a; 
 float u  = dot(position - a, q)/dot(q, q);
 u   = clamp(u, 0., 1.);
 return mix(a, b, u);
}


#//Constructors
ray construct_ray(void)
{ 
 ray r;
 r.origin = vec2(0.);
 r.position = vec2(0.);
 r.prior  = vec2(0.);
 r.direction = vec2(0.);
 r.travel = 0.;
 r.range  = 0.;
 r.iteration = 0.;
 r.intersection = false;
   return r;
}

material construct_material(void)
{ 
 material m;
 m.id         = 0.;
 m.index      = 0.;
 m.roughness  = 0.;
 m.opacity = 0.;
 m.uv         = vec2(0.);
 m.normal     = vec2(0.);
 m.tangent    = vec2(0.);
 m.color      = vec3(0.);
 return m;
}

light construct_light(void)
{
 light l;
 l.position    = vec2(0.);
   l.direction   = vec2(0.);
   l.color       = vec3(0.);
 return l;
}

plot construct_plot(const in vec2 position)
{
 plot p;
 p.prior  = vec2(0.);
 p.position = position;
 p.point  = vec2(0.);
   p.ray  = vec3(0.);
  p.light  = vec3(0.);
 p.color  = vec3(0.);
 p.brdf  = vec3(0.);
 p.derivative = vec3(0.);
   p.occlusion = vec3(0.);
   p.shadow  = vec3(0.);
   p.map  = vec3(0.);
 return p;
}