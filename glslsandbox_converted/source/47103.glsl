precision mediump float;
uniform float time;
uniform vec2 resolution;

void main(void) {
 const float m=1000.0;
 float x=gl_FragCoord.y*50.0+mod(time*5000.0,m);
 float g=clamp(mod(x,m)-m/2.0,0.0,1.0)-0.5; 
 gl_FragColor=vec4(vec3(0.0,g,g),1.0);
}