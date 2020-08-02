#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const mediump float boardsegs = 1.0;

void main(void) {
 
 float scalar = (boardsegs*0.1);
 float halfscalar = scalar/2.0;
 vec2 position = (gl_FragCoord.xy / resolution.xy);
 position.x = sign(mod(position.x+mod(time/10.0, scalar),scalar)-halfscalar);
 position.y = sign(mod(position.y+mod(time/10.0, scalar),scalar)-halfscalar);
 gl_FragColor = vec4(vec3(0.0, 0.0, position.x * position.y), 1.0);

}