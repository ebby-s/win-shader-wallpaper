#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

// Air streams by WAHa.06x36^SVatG (https://www.shadertoy.com/view/Ms3fWf)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 getSkyColor(vec3 e) {
 float skyY = max(e.y, 0.0);
 float cloudY = max(-e.y, 0.0);
 return vec3(
  pow(1.0 - skyY, 2.0),
  1.0 - skyY,
  0.6 + (1.0 - skyY) * 0.4
 ) * mix(vec3(1.0), vec3(0.8, 0.8, 0.85), cloudY);
}

mat3 fromEuler(vec3 ang) {
 vec2 a1 = vec2(sin(ang.x), cos(ang.x));
 vec2 a2 = vec2(sin(ang.y), cos(ang.y));
 vec2 a3 = vec2(sin(ang.z), cos(ang.z));
 return mat3(
  vec3(a1.y * a3.y + a1.x * a2.x * a3.x, a1.y * a2.x * a3.x + a3.y * a1.x, -a2.y * a3.x),
  vec3(-a2.y * a1.x, a1.y * a2.y, a2.x),
  vec3(a3.y * a1.x * a2.x + a1.y * a3.x, a1.x * a3.x - a1.y * a3.y * a2.x, a2.y * a3.y)
 );
}

void main( void ) {
 vec2 p = (2.0 * gl_FragCoord.xy - resolution.xy) / min(resolution.x, resolution.y);
        
 vec3 ang = vec3( 0.0, -(mouse.y - 0.5) * 3.14159265 * 1.0, mouse.x * 3.1415926535 * 2.0);
 vec3 pos = vec3(0.0,0.0,0.0);
 vec3 dir = normalize(vec3(p.xy, -2.0 + length(p) * 0.15)) * fromEuler(ang);
 
 vec3 sky = getSkyColor(dir);

 vec3 color = sky;
 for(int i = 1; i < 16; i++) {
  float r = float(i) * 1.0 + 0.33;
  float z = r * dir.z / length(dir.xy);
  float a = atan(dir.y, dir.x);
  float pattern = sin(a * (4.0 * float(i)) + sin((z + time * 20.0 + float(i)) * 0.5 / (float(i) + 2.0)) * 3.0);
  color *= (1.0 + pow((pattern + 1.0) * 0.5, 4.0) * 0.1 / (length(vec2(abs(z), r)) + 5.0));
 }
 
 gl_FragColor = vec4(pow(color,vec3(0.75)), 1.0);
}
