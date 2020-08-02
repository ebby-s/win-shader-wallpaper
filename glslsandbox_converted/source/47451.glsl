#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float f(float x) {
 return 0.;
}

float g(float x) {
 return 1.7 * x;
}

float h(float x) {
 return -1.7 * x;
}

void main( void ) {
 vec2 pos = gl_FragCoord.xy / resolution.x;
 pos += .25;
 pos -= mouse;
 
 gl_FragColor = vec4(pos.x, pos.y, .5, 1.);
 
 if(pos.x < .6 && pos.x > .4 * sin(time)  && pos.y > .4  * sin(time) && pos.y < .6) {
  gl_FragColor = vec4(cos(time), sin(time), 1., 1.);
 }
 
 float d = sqrt(pow(pos.x, 2.) + pow(pos.y, 2.));
    
        if(d < .1) {
         gl_FragColor = vec4(sin(time), 1., 1., 1.);
        }
}             