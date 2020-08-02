#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int NUM_STEPS = 1;
const float PI   = 3.1415;
const float EPSILON = 1e-3;
float EPSILON_NRM = 0.;

// sea
const int ITER_GEOMETRY = 3;
const int ITER_FRAGMENT = 2;
const float SEA_HEIGHT = 0.6;
const float SEA_CHOPPY = 4.0;
const float SEA_SPEED = 0.8;
const float SEA_FREQ = 0.30;
const vec3 SEA_BASE = vec3(0.1,0.19,0.22);
const vec3 SEA_WATER_COLOR = vec3(0.8,0.9,0.6);
float SEA_TIME = 0.1;
mat2 octave_m = mat2(1.6,1.2,-1.2,1.6);

// math
mat3 fromEuler(vec3 ang) {
 vec2 a1 = vec2(sin(ang.x),cos(ang.x));
    vec2 a2 = vec2(sin(ang.y),cos(ang.y));
    vec2 a3 = vec2(sin(ang.z),cos(ang.z));
    mat3 m;
    m[0] = vec3(a1.y*a3.y+a1.x*a2.x*a3.x,a1.y*a2.x*a3.x+a3.y*a1.x,-a2.y*a3.x);
 m[1] = vec3(-a2.y*a1.x,a1.y*a2.y,a2.x);
 m[2] = vec3(a3.y*a1.x*a2.x+a1.y*a3.x,a1.x*a3.x-a1.y*a3.y*a2.x,a2.y*a3.y);
 return m;
}


mat2 m = mat2( 0.90,  0.110, -0.70,  1.00 );

float ha( float n ) {return fract(sin(n)*758.5453);}

float no( in vec3 x )
{    vec3 p = floor(x);    vec3 f = fract(x); 
    float n = p.x + p.y*57.0 + p.z*800.0;float res = mix(mix(mix( ha(n+  0.0), ha(n+  1.0),f.x), mix( ha(n+ 57.0), ha(n+ 58.0),f.x),f.y),
    mix(mix( ha(n+800.0), ha(n+801.0),f.x), mix( ha(n+857.0), ha(n+858.0),f.x),f.y),f.z);
    return res;}

float fbm( vec3 p )
{    
 float f = 0.3*cos(time*0.44);
 //float f = f_input;
    f += 0.50000*no( p ); p = p*2.02;    f -= 0.25000*no( p ); p = p*2.03;
    f += 0.12500*no( p ); p = p*2.01;    f += 0.06250*no( p ); p = p*2.04;
    f -= 0.03125*no( p );    return f/0.984375;}

float cloud(vec3 p)
{ p-=fbm(vec3(p.x,p.y,0.0)*0.27)*2.27;float a =0.0; a-=fbm(p*3.0)*2.2-1.1;
 if (a<0.0) a=0.0;a=a*a; return a;}

vec3 f2(vec3 c)
{ c+=ha(gl_FragCoord.x+gl_FragCoord.y*.9)*0.01;
 c*=0.7-length(gl_FragCoord.xy / resolution.xy - 0.2)*0.9;
 float w=length(c);
 c=mix(c*vec3(1.0,1.0,1.6),vec3(w,w,w)*vec3(1.4,1.2,1.0),w*1.1-0.5);
 return c
  ;}

float hash( vec2 p ) {
 float h = dot(p,vec2(127.1,311.7)); 
    return fract(sin(h)*43758.5453123);
}
float noise( in vec2 p ) {
    vec2 i = floor( p );
    vec2 f = fract( p ); 
 vec2 u = f*f*(3.0-2.0*f);
    return -1.0+2.0*mix( mix( hash( i + vec2(0.0,0.0) ), 
                     hash( i + vec2(1.0,0.0) ), u.x),
                mix( hash( i + vec2(0.0,1.0) ), 
                     hash( i + vec2(1.0,1.0) ), u.x), u.y);
}

// lighting
float diffuse(vec3 n,vec3 l,float p) {
    return pow(dot(n,l) * 0.4 + 0.6,p);
}
float specular(vec3 n,vec3 l,vec3 e,float s) {    
    float nrm = (s + 8.0) / (3.1415 * 8.0);
    return pow(max(dot(reflect(e,n),l),0.0),s) * nrm;
}

// sky
vec3 getSkyColor(vec3 e) {
    e.y = max(e.y,0.0);
    vec3 ret;
    ret.x = pow(1.0-e.y,2.0);
    ret.y = 1.0-e.y;
    ret.z = 0.6+(1.0-e.y)*0.4;
    return ret;
}

// sea
float sea_octave(vec2 uv, float choppy) {
    uv += noise(uv);        
    vec2 wv = 1.0-abs(sin(uv));
    vec2 swv = abs(cos(uv));    
    wv = mix(wv,swv,wv);
    return pow(1.0-pow(wv.x * wv.y,0.65),choppy);
}

float map(vec3 p) {
    float freq = SEA_FREQ;
    float amp = SEA_HEIGHT;
    float choppy = SEA_CHOPPY;
    vec2 uv = p.xz; uv.x *= 0.75;
    
    float d, h = 0.0;    
    for(int i = 0; i < ITER_GEOMETRY; i++) {        
     d = sea_octave((uv+SEA_TIME)*freq,choppy);
     d += sea_octave((uv-SEA_TIME)*freq,choppy);
        h += d * amp;        
     uv *= octave_m; freq *= 1.9; amp *= 0.22;
        choppy = mix(choppy,1.0,0.2);
    }
    return p.y - h;
}


float map_detailed(vec3 p) {
    float freq = SEA_FREQ;
    float amp = SEA_HEIGHT;
    float choppy = SEA_CHOPPY;
    vec2 uv = p.xz; uv.x *= 0.75;
    
    float d, h = 0.0;    
    for(int i = 0; i < ITER_FRAGMENT; i++) {        
     d = sea_octave((uv+SEA_TIME)*freq,choppy);
     d += sea_octave((uv-SEA_TIME)*freq,choppy);
        h += d * amp;        
     uv *= octave_m; freq *= 1.9; amp *= 0.22;
        choppy = mix(choppy,1.0,0.2);
    }
    return p.y - h;
}

vec3 getSeaColor(vec3 p, vec3 n, vec3 l, vec3 eye, vec3 dist) {  
    float fresnel = 1.0 - max(dot(n,-eye),0.0);
    fresnel = pow(fresnel,3.0) * 0.65;
        
    vec3 reflected = getSkyColor(reflect(eye,n));    
    vec3 refracted = SEA_BASE + diffuse(n,l,80.0) * SEA_WATER_COLOR * 0.12; 
    
    vec3 color = mix(refracted,reflected,fresnel);
    
    float atten = max(1.0 - dot(dist,dist) * 0.001, 0.0);
    color += SEA_WATER_COLOR * (p.y - SEA_HEIGHT) * 0.18 * atten;
    
    color += vec3(specular(n,l,eye,60.0));
    
    return color;
}

// tracing
vec3 getNormal(vec3 p, float eps) {
    vec3 n;
    n.y = map_detailed(p);    
    n.x = map_detailed(vec3(p.x+eps,p.y,p.z)) - n.y;
    n.z = map_detailed(vec3(p.x,p.y,p.z+eps)) - n.y;
    n.y = eps;
   
    return normalize(n);
}

float heightMapTracing(vec3 ori, vec3 dir, out vec3 p) {  
    float tm = 0.0;
    float tx = 1000.0;    
    float hx = map(ori + dir * tx);
    if(hx > 0.0) return tx;   
    float hm = map(ori + dir * tm);    
    float tmid = 0.0;
    for(int i = 0; i < NUM_STEPS; i++) {
        tmid = mix(tm,tx, hm/(hm-hx));                   
        p = ori + dir * tmid;                   
     float hmid = map(p);
  if(hmid < 0.0) {
         tx = tmid;
            hx = hmid;
        } else {
            tm = tmid;
            hm = hmid;
        }
    }

}

// main
void main( void ) 
{
 vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;
 position.y+=0.2; 
 vec2 coord= vec2((position.x-0.5)/position.y,0.0/(position.y+0.2));
 coord+=time*0.027+1000.; 
 float q = cloud(vec3(coord*1.0,0.222));
vec3  col =vec3(0.2,0.4,0.5) + vec3(q*vec3(0.2,0.4,0.1));
 
 float a = 1.0;
 //if (q > 0.0) a = 1.0; else a = 0.0;
 
 vec4 eff1 = vec4( f2(col),a);
  
 
 
 EPSILON_NRM = 0.1 / resolution.x;
 SEA_TIME = time * SEA_SPEED;
 
 vec2 uv = gl_FragCoord.xy / resolution.xy;
    uv = uv * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;    
    float time = time * 0.02;
        
    // ray
    vec3 ang = vec3(sin(time*3.0)*0.1,sin(time)*0.2+0.3,time);    
    vec3 ori = vec3(0.0,3.5,time*5.0);
    vec3 dir = normalize(vec3(uv.xy,-2.0)); dir.z += length(uv) * 0.15;
    dir = normalize(dir) * fromEuler(ang);
    
    // tracing
    vec3 p;
    heightMapTracing(ori,dir,p);
    vec3 dist = p - ori;
    vec3 n = getNormal(p, dot(dist,dist) * EPSILON_NRM);
    vec3 light = normalize(vec3(0.0,1.0,0.8)); 
             
    // color
    vec3 color = mix(
        getSkyColor(dir),
        getSeaColor(p,n,light,dir,dist),
     pow(smoothstep(0.0,-0.05,dir.y),0.3));
        
    // post
 gl_FragColor = vec4(pow(color,vec3(0.75)), 1.0)+eff1;
}