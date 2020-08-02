#ifdef GL_ES
precision highp float;
#endif


uniform float time;
uniform vec2  mouse;
uniform vec2  resolution;

const int maxIter = 128;

const float maxRadius = 2.0;


vec2 translation = vec2(-0.68, -0.5);

vec2 scale = vec2(3.0, 2.0);

void main () {
 gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
 
 vec2 pos = (gl_FragCoord.xy/resolution+translation)*scale;
 
     vec2 z = vec2(0.0);

 for(int i=0; i<maxIter; i++) {

  z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + pos;

  if(length(z) > maxRadius) {
          gl_FragColor.rgb += vec3(float(i)/float(maxIter))/3.0;
   break;
  }
 } 
 
}