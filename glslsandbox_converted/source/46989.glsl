#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy );
 
 vec2 posin = position;
 
 position = -vec2(1.25)+ 2.5*position; 
 
 position.x *= resolution.x/resolution.y; 
 
 position +=  0.1*vec2(cos(time*1.),sin(time*3.));
 
 

 vec3 color = vec3(0.0);

 vec2 center = vec2(0.,0.);
 
 vec2 dir = normalize(position-center);
 
 float dist = length(center - position);
 
 if(dist < 0.5){
  color = vec3(1,1.,1.);
  color.g = smoothstep(0.,1.,sin(time));
 }
 color.g = smoothstep(0.1,0.9,posin.x);
 
 color.b = smoothstep(0.1,0.9,posin.y);
  
 if(dist >0.6){
  color = vec3(0.8,0.8,0.8);
 }
  
 gl_FragColor = vec4( color, 1.0 );

}