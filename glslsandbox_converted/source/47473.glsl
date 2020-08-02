#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
varying vec2 surfacePosition;

void main(){
 vec2 pos = surfacePosition;

 const float pi = 3.14159;
 const float n = 2.;
 
 float radius = length(pos)*4. - 1.6;
 float t = atan(pos.y, pos.x)/pi;
 
 float brightness = 0.;
 
 for (float i = 0.0; i < n; i++){
  brightness += 1./n /abs( .2 * sin(6.0*pi*(t + i/n) ) - radius);
 }
 
 vec3 colorRGB = vec3(.2 ,.5, 1.) * brightness;
 
 
 if(length(pos) > radius)
 
 
 gl_FragColor = vec4(colorRGB / (colorRGB + 1.), 1.);
 
}