#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
//siliattila@gmail.com

uniform vec2 resolution;
uniform float time;

void main() {  

  vec2 p = gl_FragCoord.xy/resolution.xy;
  p-=0.5;
  p.x *=resolution.x/resolution.y;
  vec3 color = vec3(0.); 
  float c = smoothstep(0.49, 0.5, mod(-(p.x-time*0.1)*10.,1.));
  color = vec3(c);
  gl_FragColor =  vec4(color, 1.0);
}