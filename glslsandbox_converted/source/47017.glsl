#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
 vec2 pos = (gl_FragCoord.xy - resolution * 0.5) / resolution.y + mouse - 0.5;//gl_FragCoord.xy...\u51e6\u7406\u3057\u3088\u3046\u3068\u3057\u3066\u3044\u308b\u30d4\u30af\u30bb\u30eb\u306e\u5ea7\u6a19
 gl_FragColor = vec4(sign(pos), 0.0, 1.0);//gl_FragColor...\u753b\u9762\u306b\u6700\u7d42\u7684\u306b\u51fa\u529b\u3059\u308b\u8272
  
}