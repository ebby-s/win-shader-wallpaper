#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 mousex = mouse;
#define dist 0.02
#define intensity 1.5 / dist
#define pattern 20.0
#define tint vec3(1.0)
//#define tint  vec3(0.2,0.4,0.8)
#define chromaShift 0.5

/*//board pattern
vec3 tex2D(vec2 uv){
 if (uv.x <= 0.0 || uv.y <= 0.0 || uv.x >= 1.0 || uv.y >= 1.0) return vec3(0.0);
 vec3 color = vec3(0.0);
 color += mod(floor(uv.x * pattern), 2.0) * 0.3;
 color += mod(floor(uv.y * pattern), 2.0) * 0.3;
 color.rg *= uv;
 return color;
}
//*/

///*//mouse circle
vec3 tex2D(vec2 uv){
 if (uv.x == 0.0 || uv.y == 0.0 || uv.x == 1.0 || uv.y == 1.0) return vec3(0.0);
 float d = distance(uv, mousex) ;
 if (d < dist) return vec3(((dist-d)/dist),((dist-d)/dist),((dist-d)/dist))*tint;
 return vec3(0.0);
}
//*/

/*//moving circle
vec3 tex2D(vec2 uv){
 if (uv.x == 0.0 || uv.y == 0.0 || uv.x == 1.0 || uv.y == 1.0) return vec3(0.0);
 float s = time * 1.0; 
 float a = sin(time * 1.2) * 0.2 + 0.2;
 
 float d = distance(uv, 0.5+vec2(cos(s)*a, sin(s)*a)) ;
 if (d < dist) return vec3(0.2*((dist-d)/dist),0.4*((dist-d)/dist),0.8*((dist-d)/dist));
 return vec3(0.0);
}
//*/

vec3 flare(float px, float py, float pz, float cShift, float i)
{
 vec3 t=vec3(0.);
 
 //vec3 lx = vec3(.01,.01,.3);
 vec2 uv=gl_FragCoord.xy / resolution.xy-.5;
 float x = length(uv);
 uv*=pow(4.0*x,py)*px+pz;
 t.r = tex2D(clamp(uv*(1.0+cShift*chromaShift)+0.5, 0.0, 1.0)).r;
 t.g = tex2D(clamp(uv+0.5, 0.0, 1.0)).g;
 t.b = tex2D(clamp(uv*(1.0-cShift*chromaShift)+0.5, 0.0, 1.0)).b;
 t = t*t;
 t *= clamp(.6-length(uv), 0.0, 1.0);
 t *= clamp(length(uv*20.0), 0.0, 1.0);
 t *= i;
 /*
 //t=t*lx;
 S=m.xy-.5;
 S*=1.75;
 t*=clamp(1.-dot(S,S), 0.0, 1.0);
 float n=max(t.x,max(t.y,t.z)),c=n/(1.+n);
 //c=pow(c,10.0);
 t.xyz*=c;
 //*/
 return t;
}

void main( void ) 
{

 vec2 uv = gl_FragCoord.xy / resolution.xy;
 
 
 vec3 finalColor =vec3(0.0);
 
 
 
 float tt = 1.0 / abs( distance(uv, mousex) * intensity );
 float v = 1.0 / abs( length((mousex-uv) * vec2(0.03, 1.0)) * (intensity*10.0) );
 
 finalColor += tex2D(uv)*0.5;
 finalColor += vec3(tt)*tint;
 finalColor += vec3( v )*tint;
 
 finalColor += flare(0.00005, 16.0, 0.0, 0.2, 1.0);
 finalColor += flare(0.5, 2.0, 0.0, 0.1, 1.0);
 finalColor += flare(20.0, 1.0, 0.0, 0.05, 1.0);
 finalColor += flare(-10.0, 1.0, 0.0, 0.1, 1.0);
 finalColor += flare(-10.0, 2.0, 0.0, 0.05, 2.0);
 finalColor += flare(-1.0, 1.0, 0.0, 0.1, 2.0);
 finalColor += flare(-0.00005, 16.0, 0.0, 0.2, 2.0);
 
 //finalColor = vec3(uv, 0.0);
 //finalColor = vec3(m, 0.0);
 gl_FragColor = vec4( finalColor, 1.0 );

}