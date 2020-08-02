#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 pal( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )
{
    return a + b*cos( 6.28318*(c*t+d) );
}

void main( void ) {

 vec2 position = ( gl_FragCoord.xy * 2.0 -  resolution) / min(resolution.x, resolution.y);
 position *= 5.0;
 vec3 destColor = vec3(1.0, 0.0, 1.5 );
 float f = 0.05;
 float s,c;
 for(float i = 0.5; i < 10.0; i++){
  
  s = sin(time - i - c);
  c = cos(time + i + s);
  f += 0.02 / abs(length(3.0* position *f - vec2(c, s)) -0.4);
 }
        if(f>1.0) f= 1.0;
 f/=1.;
 gl_FragColor = vec4(pal( f, vec3(0.5,0.5,0.5),vec3(0.5,0.5,0.5),vec3(1.0,1.0,0.5),vec3(0.8,0.90,0.30)) , 1.0);
}