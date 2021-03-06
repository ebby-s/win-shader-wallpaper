#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
varying vec2 surfacePosition;

void main(){
 vec2 pos = surfacePosition;

 const float pi = 3.14159;
 const float n = 5.0;
 //pos-=0.5;
 pos*=0.35;
 pos.y=-pos.y;
 float t = atan(pos.y, pos.x)/pi;
 float rot = sin(1.0*pi*(t + time*0.3));
 float gridX = 0.0; float gridY=0.0;
 float c = 0.0;
 float l = .25;
 for (float i = 0.0; i < n; i++){
  //float rot = sin(1.0*pi*(t + time*0.7));
  //float l = .25;
  
   gridX = sin( 8. * pi * pos.x + gridY*gridY*1.8+c*1.5);
   gridY = sin( 8. * pi * pos.y + gridX*gridX*1.2+c*1.);
  c += abs(gridX * gridY * l) * (rot);
 }
 
 //gl_FragColor = vec4(vec3(1.5, 0.5, 0.15) * c, c);
 gl_FragColor = vec4(c,c*c,-c, 1.0);
 
}