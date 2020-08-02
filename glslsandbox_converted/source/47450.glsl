#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float f(float x){
 return 0.1;
}
 
float g(float x){
 return 1.73205080757 * x + .01;
}
 
float h(float x){
 return -1.73205080757 * x + .01;
}

void main( void ) {
 
 vec2 pos = gl_FragCoord.xy / resolution.x;
 gl_FragColor = vec4(pos.x, 1.-pos.x, 1., 0);
 
 //Circle
 //if(pos.x < .6 && pos.x > .4 && pos.y > .4 && pos.y < .6){
 // gl_FragColor = vec4(.2, sin(time) * 0.5 + 0.5, .6, 0.);
 //}
 
 vec2 uk = mouse; //vec2(sin(time) * .1 + .5, cos(time) * .1 + .3);
 
 /*
 float dist = sqrt(pow(pos.x - uk.x, 2.0) + pow(pos.y - uk.y, 2.0));
 
 if(dist < sin(time * 2.) * 0.1 + .2){
  gl_FragColor.b *= sin(5. * time) * 0.5 + 0.5;
 }*/
 
 //Triangle
 if(f(pos.x - uk.x) > pos.y - uk.y &&
    g(pos.x - uk.x) < pos.y - uk.y &&
    h(pos.x - uk.x) < pos.y - uk.y){
  gl_FragColor = vec4(.2, sin(time) * 0.5 + 0.5, .6, 0.);
 }
}