#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 tex(vec2 uv)
{
 return texture2D(backbuffer, uv).xy - 0.5;
}

void main( void ) {

 vec2 pos = ( gl_FragCoord.xy / resolution.xy) - mouse;
 vec2 uv =  ( gl_FragCoord.xy / resolution.xy );
 vec2 prev = tex(uv);
 vec2 pixel = 1./resolution;

 // \u30e9\u30d7\u30e9\u30b7\u30a2\u30f3\u30d5\u30a3\u30eb\u30bf\u3067\u52a0\u901f\u5ea6\u3092\u8a08\u7b97
 float accel = (
  tex(uv + pixel * vec2(-1, -1)).x +
  tex(uv + pixel * vec2(1, -1)).x +
  tex(uv + pixel * vec2(-1, 1)).x +
  tex(uv + pixel * vec2(1, 1)).x +
  tex(uv + pixel * vec2(0, 1)).x * 2. +
  tex(uv + pixel * vec2(1, 0)).x * 2. +
  tex(uv + pixel * vec2(0, -1)).x * 2. +
  tex(uv + pixel * vec2(-1, 0)).x * 2. +
  tex(uv).x * 4.
 ) / 16. - prev.x;
 
 // \u4f1d\u64ad\u901f\u5ea6\u3092\u639b\u3051\u308b
 accel *= 4.0;

 // \u73fe\u5728\u306e\u901f\u5ea6\u306b\u52a0\u901f\u5ea6\u3092\u8db3\u3057\u3001\u3055\u3089\u306b\u6e1b\u8870\u7387\u3092\u639b\u3051\u308b
 float velocity = (prev.y + accel) * 0.9;

 // \u9ad8\u3055\u3092\u66f4\u65b0
 float height = prev.x + velocity;

 // \u30de\u30a6\u30b9\u4f4d\u7f6e\u306b\u6ce2\u7d0b\u3092\u51fa\u3059
 if (fract(time) < 0.1) {   
  height += (sin((length(pos) - time * 20.) * 3.) * .5 + .5) / length(pos * 300.);
 }
 gl_FragColor = vec4(height + 0.5, velocity + 0.5, 0, 1);

}