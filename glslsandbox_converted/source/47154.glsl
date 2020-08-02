#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

void main(void) {

  vec2 position = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);

  float posX1 = position.x + sin(time * 1.0) * 0.1;
  float posX2 = position.x + sin(time * 4.0) * 0.1;
  float posX3 = position.x + sin(time * 4.0) * 0.1;

  float posY1 = position.y + tan(time * 1.0) * 0.1;
  float posY2 = position.y + tan(time * 3.0) * 0.1;
  float posY3 = position.y + tan(time * 3.0) * 0.1;

  float orb1 = 0.1 / length(vec2(posX1, posY1));
  float orb2 = 0.1 / length(vec2(posX2, posY2));
  float orb3 = 0.1 / length(vec2(posX3, posY3));

  float r = ceil(orb1 + orb2 + orb3) * 1.0;
  float g = ceil(orb1 + orb2 + orb3) * 0.8;
  float b = ceil(orb1 + orb2 + orb3) * 0.5;

  gl_FragColor = vec4(vec3(r, b, g), 1.0);
}