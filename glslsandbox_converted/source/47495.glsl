#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float remap (float value, float fromLow, float fromHigh, float toLow, float toHigh)
{
 return  toLow + (value - fromLow) * (toHigh -toLow) / (fromHigh - fromLow);
}


void main( void ) 
{
 float aspectRatio = resolution.x / resolution.y;
 vec2 uv = gl_FragCoord.xy / resolution.xy;
 uv.x *= aspectRatio;
 
 float radius = 0.3;
 float radius2 = 0.1;
 
 vec2 center = vec2(0.4, 0.5);
 vec2 center2 = vec2(1., 0.5);
 center2.x = remap(sin(time * 0.9), -1., 1., 0. + radius2, 2. - radius2); 
 
 float d = distance(center, uv);
 float r = smoothstep(radius, radius - 0.01, d);
 
 d = distance(center2, uv);
 float g = smoothstep(radius2, radius2 - 0.01, d);
 
 gl_FragColor = vec4(r, g, 0, 1);
}