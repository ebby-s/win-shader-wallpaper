#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

void main(){
 
 float pos = 0.5;
 float lung = 0.2;
 float posScale;
        vec2 glposition = (gl_FragCoord.xy / resolution.xy);
 
      
 vec4 color = vec4(1.0,1.0,1.0,1.0);
 //posScale = (-1.0 + (1.0 + pos)) * lung + pos;
 posScale = pos * (1.0 + lung);
 if(glposition.x >= posScale-lung && glposition.x <= posScale)
 {
  //color.rgb = vec3(glposition.x);
  color.rgb = vec3(1.0-(posScale-glposition.x)/lung);
  //color.rgb = vec3((glposition.x+lung)/(glposition.x));
 }
 else
 {
  color.rgba = vec4(.0); 
 } 
 

   gl_FragColor = color;
}