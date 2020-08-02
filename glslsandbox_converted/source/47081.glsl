//fruityripple 
#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 resolution;
void main(void) {

 vec2 uv = ( gl_FragCoord.xy / resolution.xy );
 vec2 vx = ( gl_FragCoord.xy / uv);

 float f1=sin(sqrt(uv.x*uv.y))/sin(uv.y*sqrt(uv.x*vx.x));
 float f2=1.0*sin(time);
 float c1 = 3.0*f2 - (3.*length(2.*uv-sin(time)));

 gl_FragColor = vec4(pow(max(f1-sin(c1*f2),2.5),0.5-sin(time*5.)),pow(max(-c1,0.5),0.5),atan(sqrt(f1*sin(f1-c1))), 1.0 );
}