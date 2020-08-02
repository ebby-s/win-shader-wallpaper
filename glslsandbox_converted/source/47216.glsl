#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2  mouse;
uniform vec2  resolution;
uniform vec2  surfaceSize;
varying vec2  surfacePosition;

vec2  c1  = vec2(0., 0);
float r1  = 0.5;
vec4  f   = vec4(1.0,1.0,1.0,1.0);
vec4  b   = vec4(0.0, 0.0, 0.0, 1.0);

float disk(vec2 p, vec2 c, float r){
 float  t = mix(0. , 1., abs(distance(p,c)));
 return t;
}

void main( void ) {
 vec2   sp = surfacePosition;
 vec2   p = sp-sp*(sin(time/30.0)*0.5+1.5);//(gl_FragCoord.xy * 2.0 - resolution) /min(resolution.x,resolution.y);
 
 float  t1 = 1.0-disk(p,c1,r1);
 
 t1 += dot(p,1.0-p);
 t1 = fract(t1/4.0);
 
 gl_FragColor = mix(b, f, t1);
}