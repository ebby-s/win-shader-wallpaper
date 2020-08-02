#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
varying vec2 surfacePosition;

void main(){
 vec2 pos = 2.*surfacePosition;

 const float pi = 3.14159;
 const float n = 2.;
 
 float radius = length(pos)*4. - 1.6;
 float t = atan(pos.y, pos.x)/pi;
 
 t += 0.002*cos(64.*pi*t+time*pi*1.2);
 t += 0.02*cos(pi*t+time/2.1);
 t += 0.01*cos(2.*pi*t-time*1.23);
 t += 0.006*cos(3.*pi*t-time/3.33);
 
 float brightness = 0.;
 
 for (float i = 0.0; i < n; i++){
  brightness += abs( .1 * (sin(6.0*pi*(t + i/n) + 0.5*(time+cos(time*pi/2.34567890))*pi) + 3.*sin(5.0*pi*(t + 2.*i/n) )) - radius) / (n-1.9);
 }
 
 vec3 colorRGB = vec3(.88,.99,.75) * brightness;
 
 
 if(length(pos) > radius) colorRGB *= pow(  (length(pos)+1.6) / (radius+1.6)  ,  4. );
 
 
 gl_FragColor = vec4(colorRGB / (colorRGB + 1.), 1.);
 
}