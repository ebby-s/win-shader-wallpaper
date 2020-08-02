#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {
        float dist= 2.;
 vec2 p = gl_FragCoord.xy / resolution.xy * 2. - 1.;
 p.x *= resolution.x/resolution.y;
 p*=2.;
 float a = atan(p.y,p.x);
 float l = length(p);
        float c = sin((l+cos(a*1.-sin(a*3.)-time*2.2)+a*2.-time*1.));
 
 if((l*dist)<3.14/2.) c*=sin(l*dist);
 gl_FragColor = vec4( c,c*c,-c,1.0 );
}