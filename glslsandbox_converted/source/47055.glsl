#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float speedX = 1.89 * 0.2;
float speedY = 1.2436 * 0.2;

void ball(vec2 offset, vec2 position, float time, float size) {
 float x = abs(mod(time * speedX + offset.x, 2.0) - 1.0);
 float y = abs(mod(time * speedY + offset.y, 2.0) - 1.0);
 gl_FragColor.rgb += max(vec3(0.0), vec3(size / 10.0 - distance(vec2(x, y), position)) * (100.0 / size));
}

void main( void ) {
 
 vec2 position = gl_FragCoord.xy / resolution.xy;
 position.x = pow(position.x, 3.0);
 
 for(int i = 0; i < 50; ++i)
  ball(
   vec2(float(i) * 0.3, i),
   position,
   time + float(i * 3),
   .3
  );
}