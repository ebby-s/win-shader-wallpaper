#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float circle(float x, float y) {
 return length(vec2(x,y));
}

float square(float x, float y) {
 return max(abs(x),abs(y));
}

float thin_line(float f) {
 return f>0.48 && f<0.5?1.0:0.;
}

float filled(float f) {
 return f<0.5?1.0:0.;
}


void main( void ) {
 float t;
 t = time;
 //t = mouse.x*10.0;

 vec2 p = ( gl_FragCoord.xy / resolution.xy );
 
 p.y*=resolution.y/resolution.x;


 vec3 black = vec3(0);
 vec3 white = vec3(1);
 vec3 brown = vec3(0.5,0.4,0.2);
 vec3 green = vec3(.2,.4,.2);


 float count = 5.;//(1.+sin(t))*.5*30.0+1.;
 float x = fract(p.x*count);
 float y = fract(p.y*count);
 x*=2.0;
 y*=2.0;
 x-=1.0;
 y-=1.0;


 float f = filled(circle(x,y));

 vec3 a,b,c,d, non_animated, animated;
 a = mix(black, white, f);
 b = mix(green, brown, f);
 animated=mix(a,b,abs(sin(p.x*100.0+t)));
 non_animated=mix(a,b,abs(sin(p.x*10.0)));
 
 d=mix(non_animated,animated,f);
 
 c=d;

 gl_FragColor = vec4( c, 1.0 );

}