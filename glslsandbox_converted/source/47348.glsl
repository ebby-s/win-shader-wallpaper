#ifdef GL_ES
precision mediump float;
#endif

//instagram.com/beastle9end

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PHI = sqrt(5.0) * 0.5 + 0.5;

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
 

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main( void ) {

 vec2 texcoord = (gl_FragCoord.xy / resolution.xy);
 texcoord = texcoord * 2.0 - 1.0;
 texcoord = texcoord * mat2(sin(time), cos(time), -cos(time), sin(time));
 texcoord = texcoord * 0.5 + 0.5;
 
 texcoord.x += sin(texcoord.y* 128.0) * 0.005;
 texcoord.y += sin(texcoord.x * 128.0) * 0.005;
 
 vec3 color = normalize(vec3(texcoord.x * 2.0, texcoord.y * 2.0, (1.0 - texcoord.x) * 2.0)+1.0)-0.5;
      color = sqrt(color);
      color = normalize(color);
      color = color * color;
      color = clamp(color, 0.0, 1.0);

 vec3 c = color;
 if(c.r > 0.5 && c.g > 0.5 || c.g > 0.5 && c.b > 0.5 || c.r > 0.5 && c.b > 0.5)
 {
  c = vec3(0.0);
 }
 
 vec3 hsv = rgb2hsv(c);
 hsv.r += time;
 
 vec3 rgb = hsv2rgb(hsv);
 
 gl_FragColor = vec4(rgb, 1.0 );

}