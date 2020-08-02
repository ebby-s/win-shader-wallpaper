#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif


uniform vec3                iResolution;
uniform float               iGlobalTime;
uniform sampler2D           iChannel0;
varying vec2                texCoord;



void main() {

 float stongth = 0.3;
     vec2 uv = gl_FragCoord.xy;
     float waveu = sin((uv.y + iGlobalTime) * 20.0) * 0.5 * 0.05 * stongth;
     gl_FragColor = texture2D(iChannel0, uv + vec2(waveu, 0));
}