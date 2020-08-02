#ifdef GL_ES
precision mediump float;
#endif

// Inspired by \"The Fractal Geometry of Nature\", Benoit B. Mandelbrot, 1977, 1983, page 57
// Change the resolution dropdown to 0.5.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define MAX_ITERATIONS 14

mat2 rotateAndScale(float angle, float scale) {
 float s = sin(angle);
 float c = cos(angle);
 mat2 m = mat2(c, -s, s, c);
 return m * scale;
}

bool pointInTriangle(vec2 p1, vec2 p2, vec2 p3, vec2 pos)
{
 // http://totologic.blogspot.fr/2014/01/accurate-point-in-triangle-test.html
 float denominator = (p1.x*(p2.y - p3.y) + p1.y*(p3.x - p2.x) + p2.x*p3.y - p2.y*p3.x);
 float t1 = (pos.x*(p3.y - p1.y) + pos.y*(p1.x - p3.x) - p1.x*p3.y + p1.y*p3.x) / denominator;
 float t2 = (pos.x*(p2.y - p1.y) + pos.y*(p1.x - p2.x) - p1.x*p2.y + p1.y*p2.x) / -denominator;
 float s = t1 + t2;

 return 0. <= t1 && t1 <= 1. && 0. <= t2 && t2 <= 1. && s <= 1.;
}

void main( void ) {

 vec2 aspect = resolution / resolution.x;
 vec2 position = gl_FragCoord.xy * aspect / resolution;
 mat2 topMatrix = rotateAndScale(-0.97, 0.55);
 float branchDistance = topMatrix[0].x;
 float minSize = max(mouse.x, 10.0 / resolution.x);
 
 vec2 start = vec2(0.05, 0.1);
 vec2 end = vec2(0.95, 0.1);
 vec2 top = start + topMatrix * (end - start);
 vec3 color = (position.y > start.y) ? vec3(0.3, 0.5, 0.6) : vec3(0.5, 0.3, 0.1);
 
 for (int i = 0; i < MAX_ITERATIONS; ++i) {
  vec2 delta = end - start;
  float baseDistance = length(delta);
  vec2 branch1 = start + delta * branchDistance * 0.94;
  vec2 branch2 = start + delta * branchDistance / 0.94;
  if (pointInTriangle(branch1, branch2, top, position)) {
   color = vec3(1.0);
   break;
  }
  // Left branch
  vec2 newTop = branch1 + topMatrix * (top - branch1);
  if (pointInTriangle(branch1, top, newTop, position)) {
   if (baseDistance < minSize) {
    color = vec3(0.4, 1.0, 0.45);
    break;
   }
   start = branch1;
   end = top;
   top = newTop;
   continue;
  }
  // Right branch
  newTop = top + topMatrix * (branch2 - top);
  if (pointInTriangle(top, branch2, newTop, position)) {
   if (baseDistance < minSize) {
    color = vec3(0.4, 1.0, 0.45);
    break;
   }
   start = top;
   end = branch2;
   top = newTop;
   continue;
  }
  if (baseDistance < minSize) {
   break;
  }
  // Left side
  newTop = start + topMatrix * (branch1 - start);
  if (pointInTriangle(start, branch1, newTop, position)) {
   end = branch1;
   top = newTop;
   continue;
  }
  // Right side
  newTop = branch2 + topMatrix * (end - branch2);
  if (pointInTriangle(branch2, end, newTop, position)) {
   start = branch2;
   top = newTop;
   continue;
  }
 }

 gl_FragColor = vec4( vec3( color ), 1.0 );

}