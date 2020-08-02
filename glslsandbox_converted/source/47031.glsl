#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float noise(vec2 p){
 float a1 = 321.0;
 float b1 = 1.0;
 float c1 = 12.0;
 
 float a2 = 60.0;
 float b2 = 2.0;
 float c2 = 2.0;
 
 float a3 = 125.0;
 float b3 = 3.0;
 float c3 = 10.0; 
 
 return fract(sin(p.x*a1+b1)*c1*sin(p.y*a2+b2)*c2*sin(p.y*a3+b3)*c3 );
}


void main( void ) {
 
 vec2 p = gl_FragCoord.xy/resolution.xy;
 p.x *= resolution.x/resolution.y;
 
 p -= vec2(1.0,0.5);
 
 float theta = sin(time)*1.0;
 
 mat2 rm = mat2(cos(theta),-sin(theta),sin(theta),cos(theta));
 
 p = rm * p;
 
 float x  = floor(mod(p.x*3.0  +  fract(sin(p.x*2.0)*5.0)  ,2.0));
 
 
 theta =  -sin(time)*3.0;
 
 rm = mat2(cos(theta),-sin(theta),sin(theta),cos(theta));
 
 p = rm * p; 
 
        float y  = floor(mod(p.y*3.0  +  fract(sin(p.y*2.0)*5.0)  ,2.0));
 
 //x =  p.x;
 
 
 //x = noise(p);
 //y = noise(p);

 x = x*y;
 
 vec3 r = (1.0-x) * vec3(sin(time),0.0,0.0); 
 vec3 g = (1.0-x) * vec3(0.0,cos(time),0.0); 
 vec3 b = (1.0-x) * vec3(0.0,0.0,sin(time)+3.14); 

 vec3 c = r+g+b;
 
 gl_FragColor = vec4(c,1);

}