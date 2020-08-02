#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main(void) {
 float radius = 100.0;
 vec2 center = vec2(int(resolution.x / 2.0), int(resolution.y / 2.0));
 
 vec3 color = vec3(0, 0, 0);
 
 float degreesPerIteration = 360.0 / float(50);
 for(int i = 0; i < 50; i++) {
  float currentRot = degreesPerIteration * float(i) + time * 10.0;
  
  vec2 circlePoint = vec2(int(cos(radians(currentRot)) * radius), 
     int(sin(radians(currentRot)) * radius))
     + 
       vec2(int(cos(radians(currentRot)) * sin(time + currentRot) * 10.0), 
     int(sin(radians(currentRot)) * sin(time + currentRot) * 10.0)
     ) + center;
  for(int j = 0; j < 100; j++) {
   vec2 linePoint = 
    vec2(
            int(cos(radians(currentRot)) * float(j)), 
            int(sin(radians(currentRot)) * float(j))
    ) + 
    vec2(
     int(cos(radians(currentRot)) * sin(time + currentRot) * 10.0), 
     int(sin(radians(currentRot)) * sin(time + currentRot) * 10.0)
    ) + center;
   
   if(distance(gl_FragCoord.xy, linePoint) < float(j) / 20.0) {
    color = vec3(1, 1, 1) / distance(gl_FragCoord.xy, center) * radius / 3.0;
   }
  }
  if(distance(gl_FragCoord.xy, circlePoint) < 5.0) {
   color = vec3(1, 1, 1) / distance(gl_FragCoord.xy, circlePoint);
  }
 }
 
 gl_FragColor = vec4(color, 1.0 );
}


