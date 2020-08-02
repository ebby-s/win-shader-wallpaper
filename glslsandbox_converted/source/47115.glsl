#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {
  vec4 o = gl_FragColor;
  vec2 i = gl_FragCoord.xy;  
  float c = time/0.5;
  o-=o; i/=18.; 

  float x=i.x;
  for (int n=0; n<1; n++) {
     x-=3.; 
       if (x<3.&&x>0.) {
       int j = int(i.y);
       //j = ( x<0.? 0:
       //      j==5? 972980223: j==4? 690407533: j==3? 704642687: j==2? 696556137:j==1? 972881535: 0 
       //    ) / int(pow(2.,floor(30.-x-mod(floor(c),10.)*3.)));
        
 
       j = ( x<0.? 0:
             j==5? 123456789: j==4? 564738275: j==3? 673856739: j==2? 573857385:j==1? 57485963: 0 
          )/int(pow(2.,floor(30.-x-mod(floor(c),10.)*3.))); 
                         
        
        
       //j = int(i.y);
       //j = (j==5?9:j==4?0:j==3?0:j==2?0:j==1?0:1) /int(pow(2., 2.-x-0.));
       //j = (j == 5 && x == 1. ? 1 : 0);
        
        
       o = vec4(j - j / 2 * 2);
       break;
    }
    c/=9.0;
  }
 gl_FragColor = o;
}