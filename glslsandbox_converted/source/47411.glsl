#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
    
    float sum = 0.0;
    float size = resolution.x / 12.0;
    float g = 0.93;
    int num = 100;
    for (int k = 0; k < 10; ++k) {
 for (int j = 0; j < 10; ++j) {
     for (int i = 0; i < 10; ++i) {
  vec3 position = vec3(0.0, 0.0, 0.0);
  position = vec3(resolution.x - float(i*40) * 0.5 - 100.0, resolution.y - float(j*75) * 0.5 - 15.0, float(k)*sin(time));

  //position.x += float(i*40) * 0.25;
  //position.y += resolution.y - float(j*75) * 0.25;
      
  float dist = length(gl_FragCoord.xy - position.xy / position.z);
  sum += size / pow(dist*7., g);
  
  
     }
  
     
 }
    }
    
    vec4 color = vec4(0,0,1,1);
    float val = sum / float(num);
    color = vec4(0, val*0.4, val*0.6, 1);
    
    gl_FragColor = vec4(color);
}