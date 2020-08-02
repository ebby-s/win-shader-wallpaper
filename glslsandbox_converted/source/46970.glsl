#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy );
 
 vec2 toyuandian = position;
 
 
 vec3 color = vec3(0.0);
 position = position*2.-vec2(.0); 
 
 for(int i=0;i<20;++i){
  float dis = length(position - vec2(position.x,float(i)/10.));
  dis = pow(dis,0.1);
  color.g += smoothstep(1.,0.,dis); 
 }
 color.b = color.g - 0.7;
 color.r = color.b + 0.5;
 
 
 for(int j=0;j<4;++j){
  toyuandian = toyuandian*2. - vec2(1.0);
  
  toyuandian.y += float(j)/1.;
 
  float y = toyuandian.x*0.4*sin(time);
 
  float toydis = length(toyuandian - vec2(toyuandian.x,y));
  if(toydis < 0.09){
  color.r=color.g=color.r = smoothstep(0.,1.,pow(toydis,.2));
  
  }
 }
 
 gl_FragColor = vec4( color, 1.0 );

}