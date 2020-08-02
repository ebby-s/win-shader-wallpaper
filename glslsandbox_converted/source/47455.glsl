#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

//author: tigrou dot ind at gmail dot com
uniform vec2 resolution;
uniform float time;

float tri(vec2 position)
{
 float color = 0.0;
 float a = -(position.x * sqrt(3.0) -0.2) - position.y;
 float b = position.x * sqrt(3.0) - position.y + 0.2;
 float c = position.y + 0.1;
 
 float result = min(min(a, b), c);
 if(result > 0.0) return 1.0;
 return -1.0;
}

void main( void ) {

 vec2 pos = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5, 0.5);
   
        pos = vec2(pos.x * cos(time) - pos.y * sin(time), 
     pos.y * cos(time) + pos.x * sin(time));
 
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
 
        if(result < 0.0) result = 0.0; 
 
 gl_FragColor = vec4( mix(vec3(0.5, 0.0, 1.0), vec3(0.0,0.0,0.0), result), 1.0 );

}