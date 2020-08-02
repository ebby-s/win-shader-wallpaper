#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct Ray {
 vec3 pos;
 vec3 dir;
};
 
float distanceFunction(vec3 pos)
{
 return length(pos) - 5.0;
}

void main( void ) {

 vec2 pos = (gl_FragCoord.xy - resolution * 0.5)  / resolution.y + mouse - 0.5;
 Ray ray;
 ray.pos = vec3(0.0, 0.0, -10.0);
 ray.dir = normalize(vec3(pos * 3.0, 1.0));
 float d;
 for(int i = 0; i < 6; ++i)
 {
  d = distanceFunction(ray.pos);
  ray.pos += d * ray.dir;
  if (abs(d) < 0.001) break;
 }
 gl_FragColor = vec4(vec3(d), 1.0);
}