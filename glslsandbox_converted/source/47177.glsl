#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define time (1.*time)
#define pi 3.14159
#define tau 6.28318

mat2 rotate( in float theta ) {
 float c = cos(theta), s = sin(theta);
 return mat2(c, -s, s, c);
}

void main( void ) {
 float a = resolution.x/resolution.y;
 vec2 p = (2.*gl_FragCoord.xy - resolution.xy) / resolution.y,
  mp = mouse*2.-1.;
 mp.x*=a;
 vec3 color = vec3(0);
 //color += vec3(.5+.5*sin(32.*distance(p, mp)-time));

 vec2 p0 = p-mp;
 float theta = atan(p0.y, p0.x)/tau;
 float alpha = exp(-4.*fract(1.*(theta-time+length(p0))));
 //float alpha = .5+.5*sin(tau*10.*(theta-time+length(p0)));
 color += alpha;
 color = mix(vec3(.08,.07,.05), vec3(.5,.7,.98), alpha);
 
 gl_FragColor = vec4(color, 1);
}