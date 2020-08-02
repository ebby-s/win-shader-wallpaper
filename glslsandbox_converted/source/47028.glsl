#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

const float t = 0.1;
const float a = 0.01;

vec2 position;
vec2 pixel;

vec4 prevColor(vec2 offset)
{
 return texture2D(backbuffer, position + pixel * offset);
}

float prevU(int offsetX, int offsetY, int offsetT)
{
 vec4 color = prevColor(vec2(offsetX, offsetY));

 return (offsetT == 1 ? color.b : color.a) * 2.0 - 1.0;
}

vec4 encodeU(float now, float past)
{
 //return vec4(now, 0.0, 0.0, past);
 return vec4(0.0, 0.0, (now + 1.0) / 2.0, (past + 1.0) / 2.0);
}

void main( void ) {
 
 position = ( gl_FragCoord.xy / resolution.xy );
 pixel = 1./resolution;
 
 float h = min(pixel.x, pixel.y);

 float u;
 if (position.x <= pixel.x || position.x >= 1.0 - pixel.x
  || position.y <= pixel.y || position.y >= 1.0 - pixel.y)
 { // boundary conditions
  u = 0.0;
 }
 else
 { // wave equation
  float u_xx = 0.0;
  u_xx +=      prevU( 1, 0, 1);
  u_xx -= 2. * prevU( 0, 0, 1);
  u_xx +=      prevU(-1, 0, 1);
  //u_xx /= pixel.x * pixel.x;
  u_xx /= h*h;
  
  float u_yy = 0.0;
  u_yy +=      prevU(0,  1, 1);
  u_yy -= 2. * prevU(0,  0, 1);
  u_yy +=      prevU(0, -1, 1);
  //u_yy /= pixel.y * pixel.y;
  u_yy /= h*h;
  
  u = 0.0;
  u += 2. * prevU(0, 0, 1);
  u -=      prevU(0, 0, 2);
  u += a*a * t*t * ( u_xx + u_yy );
 }
 
 // Initial undisturbed conditions
 if (mod(time, 10.0) < 0.1)
 {
  u = 0.0;
  //if (distance(position, vec2(0.5, 0.5)) < 0.1) u = 0.9;
  //if (distance(vec2(position.x / resolution.x * resolution.y, position.y), vec2(0.5, 0.5)) < 0.1) u = 0.9;
  //if (distance(gl_FragCoord.xy, mouse*resolution) < 5.0) u = 0.9;
 }


 //if (distance(position, mouse) < 0.05)
 if (distance(gl_FragCoord.xy, mouse*resolution) < 10.0)
 { // disturbalce
  /*float rnd1 = mod(fract(sin(dot(position + time * 0.001, vec2(14.9898,78.233))) * 43758.5453), 1.0);
  if (rnd1 > 0.01) {
   u = 0.5;
  } else {
   u = 0.25;
  }*/
  
  //u = 0.5 * ( sin(time*2.0) + 1.0 ) / 2.0;
  u = 0.75 * sin(time*4.0);
  //u = 0.5 + 0.5 * ( sin(time) + 1.0 ) / 2.0;
  //u = 0.5;
  //if (mod(time, 4.0) < 0.1) u = -0.9;
 }
 
 gl_FragColor = encodeU(u, prevU(0, 0, 1));
 
 
 // Adds mouse-centered light reflections on R and G components
 vec2 grad = vec2(prevU(1,0,1)-prevU(-1,0,1), prevU(0,1,1)-prevU(0,-1,1)); // Gradient at current position
 vec2 v = mouse - gl_FragCoord.xy / resolution;      // Vector from pos to mouse
 float f = -dot(grad, v/length(v));      // Resulting factor 
 gl_FragColor.rg = vec2(log(1.0+f) / (0.7+0.7*length(v)));   // Uses factor in RG channels after transformation

}