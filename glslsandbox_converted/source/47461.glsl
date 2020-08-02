// http://glslsandbox.com/e#40624.3

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D tex;

void main(void) {
 vec2 cPos = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
 float ratio = resolution.x / resolution.y;
 cPos.x *= ratio;
 
 float cLength = length(cPos);

 float speed = 3.0;
 vec2 uv = gl_FragCoord.xy / resolution.xy + (cPos / cLength) * (cos(cLength * 10.7 - time * speed) )* 0.9;
       uv +=  (cPos / cLength) * (cos((uv) * 3.2 - time*0.4788 * speed) )* 0.7;
 uv*=.6;
 //gl_FragColor = vec4(vec3(1.0 - distance(vec2(0.5), uv),0.0, 0.0), 1.0);
 gl_FragColor = vec4(vec3(uv.x, uv.y, uv.y), 1.0);
}