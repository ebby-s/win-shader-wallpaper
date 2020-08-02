#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives: enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

float smoothNoise(vec2 p) {
 
 vec2 f = fract(p); p-=f; f *= f*(3.-f-f); 
    
    return dot(mat2(fract(sin(vec4(0, 1, 27, 28) + p.x+p.y*27.) * 1e5))*vec2(1.-f.y,f.y), vec2(1.-f.x, f.x));

}

float fractalNoise(vec2 p) {
    return smoothNoise(p)*0.5333 + smoothNoise(p*2.)*0.2667 + smoothNoise(p*4.)*0.1333 + smoothNoise(p*8.)*0.0667;
    
}

float nestedNoise(vec2 p) {
    
    vec2 m = vec2(time, -time)*.5;
    float x = fractalNoise(p + m);
    float y = fractalNoise(p + m.yx + x);
    float z = fractalNoise(p - m - x + y);
    return fractalNoise(p + vec2(x, y) + vec2(y, z) + vec2(z, x) + length(vec3(x, y, z))*0.25);
    
}

void main(void) {
  vec2 position = gl_FragCoord.xy / resolution.xy + surfacePosition;
 
  position.x += time / 3.0;
  position.y += sin(time - position.x * 2.0) / (mouse.x * 50.0 + 5.0);

  vec3 c1 = vec3(.4, .6, 1.);
  vec3 c2 = vec3(.1, .2, 1.);
  /**/ if (position.y < -abs(sin(position.x * 20. /*  */)) / 10. + .4)
    gl_FragColor = vec4(mix(c1 * 1.2, c2 * 1.2, nestedNoise(position * 4.)), 1.);
  else if (position.y < -abs(sin(position.x * 20. - time)) / 15. + .5)
    gl_FragColor = vec4(mix(c1 * 0.9, c2 * 0.9, nestedNoise(position * 5.)), 1.);
  else if (position.y < -abs(sin(position.x * 30. + time)) / 15. + .6)
    gl_FragColor = vec4(mix(c1 * 0.7, c2 * 0.7, nestedNoise(position * 6.)), 1.);
  else
    gl_FragColor = vec4(1., 1., 1., 1.);
}