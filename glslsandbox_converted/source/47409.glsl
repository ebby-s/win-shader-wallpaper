#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

uniform sampler2D bb;

#define chromaShift 0.5

float subsubflare(vec2 uv, vec2 point){
 return texture2D(bb, uv).a;
 float d = distance(uv, point) ;
 return step(d, 0.02) * (0.02-d)/0.02;
}

mat2 rotmat2d(float angle){
 return mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
}

vec3 subflare(vec2 uv, vec2 point, float px, float py, float pz, float cShift, float i)
{
 
 uv-=.5;
 float x = length(uv);
 uv *= pow(4.0*x,py)*px+pz;
 
 vec3 t=vec3(0.);
 t.r = subsubflare(clamp(uv*(1.0+cShift*chromaShift)+0.5, 0.0, 1.0), point);
 t.g = subsubflare(clamp(uv+0.5, 0.0, 1.0), point);
 t.b = subsubflare(clamp(uv*(1.0-cShift*chromaShift)+0.5, 0.0, 1.0), point);
 t = t*t;
 t *= clamp(.6-length(uv), 0.0, 1.0);
 t *= clamp(length(uv*20.0), 0.0, 1.0);
 t *= i;
 return t;
}

vec3 flare(vec2 point, vec2 uv){
 float d = distance(uv, point) ; 
 float tt = 1.0 / abs( d * 75.0 );
 mat2 rm1 = rotmat2d(3.1415 * 0.25);
 mat2 rm2 = rotmat2d(3.1415 * 0.75);
 float v = 1.0 / abs( length((point-uv) * vec2(0.03, 1.0)) * (350.0) );
 float v2 = 1.0 / abs( length((point-uv) * vec2(1.0, 0.09)) * (1750.0) );
 float v3 = 1.0 / abs( length((rm1*(point-uv)) * (vec2(1.0, 0.09))) * (1750.0) );
 float v4 = 1.0 / abs( length((rm2*(point-uv)) * (vec2(1.0, 0.09))) * (1750.0) );
 
 vec3 finalColor = vec3(subsubflare(uv, point)*0.5);
 finalColor += vec3(tt);
 finalColor += vec3( v );
 finalColor += vec3( v2 );
 finalColor += vec3( v3 );
 finalColor += vec3( v4 );
 
 finalColor += subflare(uv, point, 0.00005, 16.0, 0.0, 0.2, 1.0);
 finalColor += subflare(uv, point, 0.5, 2.0, 0.0, 0.1, 1.0);
 finalColor += subflare(uv, point, 20.0, 1.0, 0.0, 0.05, 1.0);
 finalColor += subflare(uv, point, -10.0, 1.0, 0.0, 0.1, 1.0);
 finalColor += subflare(uv, point, -10.0, 2.0, 0.0, 0.05, 2.0);
 finalColor += subflare(uv, point, -1.0, 1.0, 0.0, 0.1, 2.0);
 finalColor += subflare(uv, point, -0.00005, 16.0, 0.0, 0.2, 2.0);
 return finalColor;
}

uniform vec2 mouse;

void main( void ) 
{

 vec2 UV = gl_FragCoord.xy / resolution.xy;
 vec2 ratio = vec2(1.0);
  
 float d = distance(UV, mouse) ; 
 gl_FragColor = vec4( flare(((mouse * 2.0 - 1.0) * ratio) * 0.5 + 0.5, (UV * 2.0 - 1.0) * ratio * 0.5 + 0.5), 1.0 / abs( d * 75.0 ) );

}