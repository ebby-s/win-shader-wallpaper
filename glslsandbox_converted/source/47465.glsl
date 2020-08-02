#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
varying vec2 surfacePosition;

void main(){
 vec2 pos = surfacePosition;

 const float pi = 3.14159;
 const float n = 9.0;
 const float rn = 1.0 / n;
 
 float radius = length(pos)*                 4.0 - 1.6;
 float t = sin(pos.y)/pi + time/100.0;
 
 float color = 0.0;
 
 
 
 for (float i = 0.0; i < n; i++){
  color += 1.0 / abs(        0.2 * sin(6.0*pi*(t + i/n)) - radius)*rn;
 }
 
 vec3 colorRGB = vec3(0.2,0.5,1.0) * color;
 
 gl_FragColor = vec4(colorRGB / (colorRGB+1.0), color);
 
}