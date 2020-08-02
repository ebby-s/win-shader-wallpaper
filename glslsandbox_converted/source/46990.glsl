#ifdef GL_ES
precision mediump float;
#endif
#define pi 3.141592653589
#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void) 
{

 vec2 pos = (gl_FragCoord.xy * cos(time) + pi / (sin(time))) / 128.0;
 gl_FragColor = vec4(vec3(sin(pos.x), 
     sin(pos.y * time), 
     cos(pos / mouse).x) / sin(ceil(mouse.x * mouse.y * time) * (pi / 180.0)), 
       pos);

}