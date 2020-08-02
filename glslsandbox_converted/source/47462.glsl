// http://glslsandbox.com/e#40624.3

#ifdef GL_ES
precision highp float;
#endif

// TERVEISI\u00c4 \u00c4ITILLE

uniform float time;
uniform vec2 resolution;
uniform sampler2D tex;

void main(void) {
 vec2 cPos = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
 float ratio = resolution.x / resolution.y;
 cPos.x *= ratio;
 
 float cLength = length(cPos);

 float speed = 5.0;
 vec2 uv = gl_FragCoord.xy / resolution.xy + (cPos / cLength) * cos(cLength * 20.0 - time * speed) * 0.6;

 //gl_FragColor = vec4(vec3(1.0 - distance(vec2(0.5), uv),0.0, 0.0), 1.0);
 float f = sin(uv.x * 2. + time);
 float f2 = sin(uv.y * 2.5 + 0.89*time);
 gl_FragColor = vec4(vec3(f, pow(f, 2.), pow(f2, 6.)), 1.0);
}