#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec3 white = vec3(1., 1., 1.);
vec3 red   = vec3(1., 0., 0.);
vec3 brown   = vec3(.2, .1, 0.);
vec3 lime   = vec3(0., 1.0, 0.);

float square(float x, float y) {
 return max(abs(x), abs(y));
}

float circle(float x, float y) {
 return length(vec2(x,y));
}

float filled(float f) {
 return f<0.5  ? 1.:0.;
}

float thinLined(float f) {
 return f>0.49 && f<0.5  ? 1.:0.;
}

float thickLined(float f) {
 return f>0.4 && f<0.5  ? 1.:0.;
}

void main( void ) {

 vec2 p = ( gl_FragCoord.xy / resolution.xy );

 float x = p.x*2.0-1.0;
 float y = p.y*2.0-1.0;
 
 vec3 color = vec3(0);
 
//  float f = abs(y)+abs(x);

 float f = thickLined(square(x,y));
 float f2 = abs(sin(x*50.));
 vec3 a = white*f;
 vec3 b = mix(white,red,f);
 
 color = white*f2;
 
 gl_FragColor = vec4( color, 1.0 );

}
