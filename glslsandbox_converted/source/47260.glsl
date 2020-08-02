#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

#define CNT 5
#define SIZE 7.

uniform float time;
uniform vec2 resolution;


vec3 hsb2rgb( in vec3 c ){
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),
                             6.0)-3.0)-1.0,
                     0.0,
                     1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix( vec3(1.0), rgb, c.y);
}

vec3 colormap( float x ) {
 return hsb2rgb(vec3(x /2. +.2, .7, .75));
}

float intensity(float diff) {
 return 1. + 5.714286*diff - 38.28571*pow(diff,2.) + 45.71429*pow(diff,3.);
}


void main( void ) {

 float me = gl_FragCoord.x / resolution.x;

 
 vec3 color = vec3(0);
 
 for(int i = 1; i <= CNT; i++) {
  float pos = mod(time * pow(float(i), .7) * .1, 1.2);
  if(abs((pos - me) * SIZE) < .5)
   color += clamp(intensity((pos - me) * SIZE), 0., 1.)* colormap((float(i)-1.) / float(CNT));
 }
 
 color = pow(color, vec3(1));

 gl_FragColor = vec4( color , 1.0 );

}
