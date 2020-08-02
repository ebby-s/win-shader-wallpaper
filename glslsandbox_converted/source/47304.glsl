//Added pan/zoom using mouse left/right click
precision mediump float;

uniform vec2 resolution;
uniform float time;
varying vec2 surfacePosition;

const int iterations = 2200;
const float radius = 4.;

const float f_cx = -0.5;
const float f_cy = 0.;
const float f_sx = -0.01;
const float f_sy = .01;
const float f_z = 1.;

int fmandel(void)
{
  vec2 c = surfacePosition;
  vec2 z = c;

  for(int n = 0; n < iterations; ++n) {
    z = vec2(z.x * z.x - z.y * z.y, (2.0/(time/100.0)) * z.x * z.y) + c;
    if((z.x*z.x + z.y*z.y) > radius) {
      return n;
    }
  }
  return 0;
}

void main()
{
  int n = fmandel(); 

  gl_FragColor = vec4((-cos(0.025*float(n))+1.0)/2.0,
                      (-cos(0.08*float(n))+1.0)/2.0,
                      (-cos(0.12*float(n))+1.0)/2.0,
                      1.0);
}
