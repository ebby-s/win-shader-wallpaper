#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
//uniform vec2 resolution;
varying vec2 surfacePosition;

void main(){
 vec2 pos = surfacePosition;

 const float pi = 3.14159;
 const float n = 13.0;
 
 float radius = length(pos)*4.0 - 1.3;
 float t = atan(pos.y, pos.x)/pi/2.0;
 
 float color = 0.0;
 for (float i = 0.0; i < n; i++){
  color += 0.01/abs(0.7*cos(2.0*pi*(6.0 * t + i/n + 0.1 * time * (i/n - 0.5))) - radius);
 }
 
 gl_FragColor = vec4(vec3(1.5, 0.5, 0.15) * color, color);
 
}