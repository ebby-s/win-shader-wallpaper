



#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// marching stuff
#define NEAR_CLIPPING_PLANE 0.1
#define FAR_CLIPPING_PLANE 100.0
#define NUMBER_OF_MARCH_STEPS 100
#define EPSILON 0.01
#define DISTANCE_BIAS 0.7


#define SPHERE_RADIUS 1.5
#define BOX_X 1.0
#define BOX_Y 0.4
#define BOX_Z 1.0

mat2 rotmat() {
    float a = time;
    return mat2(cos(a), -sin(a), sin(a), cos(a));
}


float sdSphere(vec3 p, float s)
{
 return length(p) - s;
}     // distance functions from iquilezles.org/www/articles/raymarchingdf/raymarchingdf.htm


float sdBox( vec3 p, vec3 b )
{
  vec3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}


float smin( float a, float b, float k )
{
    float res = exp( -k*a ) + exp( -k*b );
    return -log( res )/k;
}

float opBlend( vec3 p )
{
    vec2 um = mouse.xy / resolution.xy-.5;
    
    vec3 sPos = vec3(p.x - sin(time) * 2., p.y, p.z);
    float d1 = sdSphere(sPos, SPHERE_RADIUS);
    float d2 = sdBox(p, vec3(BOX_X, BOX_Y, BOX_Z));
    return smin( d1, d2, 8.0 );
}

vec2 scene(vec3 position)
{
    
    vec3 translate = vec3(0.0, 0.0, 1.0);
    float materialID = 1.0;
    
    mat2 r = rotmat();
    
    vec3 box_pos = position - translate;
    
    box_pos.yz *= r; // rotate
    
    float distance_1 = opBlend(box_pos); 
    
    
    return vec2(distance_1, materialID);
    
   
}

vec2 raymarch(vec3 position, vec3 direction)
{
    
    float total_distance = NEAR_CLIPPING_PLANE;
    
     for(int i = 0 ; i < NUMBER_OF_MARCH_STEPS ; ++i)
     {
         
        vec2 result = scene(position + direction * total_distance); 
        
        if(result.x < EPSILON)
        {
          return vec2(total_distance, result.y);   
            
        }
        
        total_distance += result.x * DISTANCE_BIAS;
         
        if(total_distance > FAR_CLIPPING_PLANE)
            break;
         
     }
     
     return vec2(FAR_CLIPPING_PLANE, 0.0);
}


vec3 normal(vec3 ray_hit_position, float smoothness)
{ 
    // From https://www.shadertoy.com/view/MdSGDW
 vec3 n;
 vec2 dn = vec2(smoothness, 0.0);
 n.x = scene(ray_hit_position + dn.xyy).x - scene(ray_hit_position - dn.xyy).x;
 n.y = scene(ray_hit_position + dn.yxy).x - scene(ray_hit_position - dn.yxy).x;
 n.z = scene(ray_hit_position + dn.yyx).x - scene(ray_hit_position - dn.yyx).x;
 return normalize(n);

}


void main( void )
{
    vec2 uv = 2.0*vec2(gl_FragCoord.xy - 0.5*resolution.xy)/resolution.y;
  
    vec2 um = mouse.xy / resolution.xy-.5;
    um.x *= resolution.x/resolution.y;
 
 vec3 camera_origin = vec3(0.0, 0.0, -6.0);
        
    vec3 direction = normalize(vec3(uv, 2.5));
    
    vec2 result = raymarch(camera_origin, direction);
    
    
    float fog = pow(1.0 / (1.0 + result.x), 0.45);
    vec3 materialColor = vec3(0.0, 0.0, 0.0);
    
    if(result.y == 1.0)
     materialColor = vec3(1.0, 1.0, 1.0);
    
    vec3 intersection = camera_origin + direction * result.x;
    vec3 nrml = normal(intersection, 0.001);
    vec3 light_dir = normalize(vec3(1.0, 0.0, -1.0));
    float diffuse = dot(light_dir, nrml);
  
    diffuse = max(0.2, diffuse);
    
    vec3 light_color = vec3(1.4, 1.2, 0.7) * 1.5;
    vec3 ambient_color = vec3(0.2, 0.45, 0.6);
    
     // Combine light
    vec3 diffuseLit = materialColor * (diffuse * light_color + ambient_color);
    
    
    
    if(result.x == FAR_CLIPPING_PLANE)
      gl_FragColor = vec4(0.1, 0.5, 0.9, 1.0) * fog;
    else
     gl_FragColor = vec4(diffuseLit, 1.0) * fog;
        
 
   
}





