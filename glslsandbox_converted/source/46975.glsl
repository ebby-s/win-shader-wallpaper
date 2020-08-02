precision mediump float;


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat2 rotate(float deg) {
  return mat2(sin(deg), cos(deg), cos(deg), -sin(deg));
}

vec3 squares(vec2 p, float m, float size) {
    return mix(vec3(sin(p.x * size + m) + sin(p.y * size + m) > 0.0), vec3(sin(p.x * size + m + 1.0) + sin(p.y * size + m) < 0.0), 0.6);
}

void main( void ) {
 vec2 aspect = resolution.xy / min(resolution.x, resolution.y);
 vec2 p = gl_FragCoord.xy / min(resolution.x, resolution.y);
 vec2 n = p;
 
 p -= 0.5 * aspect; // centralize
 p *= rotate(3.14159265/4.0 + sin(time * 2.0) * 0.05); // swing
 
 //p *= 1.0/(sin(time * 0.5) * 0.5 + 0.70); // zoom 
 
 float m = time * 10.0;
 
 #define size (12.5)
 
 vec3 color = squares(p, m * 0.25, size);
 
 for (float i = 1.0; i < 7.0; i += 1.0) {
  if (distance(color, vec3(0.39, 0.39, 0.39)) < 0.02) {
   color = squares(p, m, size * pow(2.0, i));
  }
 }
 
 color -= distance(n, 0.5 * aspect);
 
 gl_FragColor = vec4 (color, 1.0);
}