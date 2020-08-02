// work in progress, made by dr1ft
// only saving so i can show my friends :)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

const float max_depth = 7.0;
const float speed = 1.;

vec2 waver(float x){
 float freq = 0.2;
 return vec2(cos(x*freq),sin(x*freq))*0.8;
}

vec2 checkerboard (vec2 offset, float depth){
 depth = mod(depth,max_depth)*4.0;
 vec2 position = (gl_FragCoord.xy / vec2(resolution.x) - vec2(0.5,0.25)) * vec2(depth) + offset;
 position += waver(depth*0.15+time*1.4);
 return vec2(clamp(sign((mod(position.x, 1.0) - 0.5) * (mod(position.y, 1.0) - 0.5)) / depth * 2.0,0.0,1.0),depth);
}

void main( void ) {
 
 vec3 color = vec3(0.0);
 //float color = 0.0;
 for (float i = 0.0; i < max_depth; i++){
  float d = i-time*speed;
  vec2 n=checkerboard(vec2(0.25,0.75), d);
  //if (n.x>color) color=n.x;
  if(n.x<=28.0 && n.x>24.0) color = vec3(n.x,0.0,0.0);
  if(n.x<=24.0 && n.x>20.0) color = vec3(0.0,n.x,0.0);
  if(n.x<=20.0 && n.x>16.0) color = vec3(0.0,0.0,n.x);
  if(n.x<=16.0 && n.x>12.0) color = vec3(n.x,n.x,0.0);
  if(n.x<=12.0 && n.x>8.0) color = vec3(0.0,n.x,n.x);
  if(n.x<=8.0 && n.x>4.0) color = vec3(n.x,0.0,n.x);
  if(n.x<=4.0 && n.x>0.0) color = vec3(n.x,n.x,0.0);
 }
 gl_FragColor = vec4(vec3(color),1.0); 
 //gl_FragColor = vec4(color,1.0);

}