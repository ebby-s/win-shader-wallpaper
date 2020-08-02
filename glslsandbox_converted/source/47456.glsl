#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

//author: tigrou dot ind at gmail dot com
//13.06.2018 : optimization

uniform vec2 resolution;
uniform float time;

float tri(vec2 pos)
{
 float a = -(pos.x * sqrt(3.0) -0.2) - pos.y;
 float b = pos.x * sqrt(3.0) - pos.y + 0.2;
 float c = pos.y + 0.1;
 
 float result = min(min(a, b), c); 
 return step(0.0, result)*2.0-1.0;
}

void main( void ) {

 vec2 pos = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5, 0.5);
 
 mat2 rot = mat2(cos(time),-sin(time), 
   sin(time), cos(time));
        pos *= rot;
 
 float zoom = 1.0/(mod(time, 1.0)+1.0)*3.0-1.0;
 pos *= zoom;
        
 vec2 invpos = vec2(pos.x, -pos.y);
 
 float result = tri(pos*0.0625)
        *tri(invpos*0.125)
        *tri(pos*0.25)
        *tri(invpos*0.5)
        *tri(pos)
        *tri(invpos*2.0)
        *tri(pos*4.0)
        *tri(invpos*8.0)
        *tri(pos*16.0)
        *tri(invpos*32.0)
        *tri(pos*64.0);
 
        result = max(result, 0.0); 
 
 gl_FragColor = vec4( mix(vec3(0.5, 0.0, 1.0), vec3(0.0,0.0,0.0), result), 1.0 );
}