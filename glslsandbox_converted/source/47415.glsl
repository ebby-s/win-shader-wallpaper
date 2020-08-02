#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
varying vec2 surfacePosition;

void main(){
 vec2 pos = surfacePosition;

 const float pi = 3.14159;
 const float n = 16.0;
 
 float radius = length(pos)*                 4.0 - 1.6;
 float t = atan(pos.y, pos.x)/pi;
 
 float color = 0.0;
 
 
 
 for (float i = 0.0; i < n; i++){
  color += 0.002/abs(        0.2 * sin(6.0*pi*(t + i/n*time*0.01)) - radius);
 }
 
 gl_FragColor = vec4(vec3(1.5, 0.5, 0.15) * color, color);
 
}