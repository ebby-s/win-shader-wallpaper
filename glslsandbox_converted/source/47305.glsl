#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 rotate( vec2 matrix, float angle ) 
{
 return vec2( matrix.x*cos(radians(angle)), matrix.x*sin(radians(angle)) ) + vec2( matrix.y*-sin(radians(angle)), matrix.y*cos(radians(angle)) );
}

void main( void ) 
{
 vec3 rColor = vec3(0.7, 0.1, 0.3)* ((sin(time*50.0)*0.5 + 3.14) * 0.066);
 vec3 gColor = vec3(0.0, 0.2, 0.5);
 vec3 bColor = vec3(0.9, 0.1, 0.0) * ((cos(time)+1.125) * 2.0);
 vec3 yColor = vec3(1, 0.0, 0.0);

 vec2 position = ( gl_FragCoord.xy / resolution.xy ) / 4.0;
 position = gl_FragCoord.xy * 2.0 - resolution;
 position /= min(resolution.x, resolution.y);
 position = rotate(position, time);
 
 float a = sin(position.y * 1.3 - time * 0.1) / 1.0;
 float b = cos(position.y * 1.4 - time * 0.2) / 1.0;
 float c = sin(position.x * 1.5 - time * 0.2 + 3.14) / 2.0;
 float d = cos(position.y * 1.6 - time * 0.5 + 3.14) / 2.0;
 
 float e = 0.51 / abs(position.x + a);
 float f = 0.71 / abs(position.x + b);
 float g = 0.51 / abs(position.y + c);
 float h = 0.51 / abs(position.x + d);
 
 vec3 color = rColor * e * gColor * f + bColor * f * g * h * 0.01;
 
 gl_FragColor = vec4(color, 1.0);

}