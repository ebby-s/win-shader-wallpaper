#ifdef GL_ES
precision mediump float;
#endif
// dashxdr was here 20120228

// Sphere_Spiral  http://glslsandbox.com/e#7109
// improved by I.G.P.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.1415927
#define PI2 (PI*2.0)
#define BALL_SIZE 2.20

void main( void ) 
{
 vec2 position = (2.0*gl_FragCoord.xy - resolution) / resolution.xx;
 position *= 11.+ mouse.x * 100.0;
 float r = length(position);
 float a = atan(position.y, position.x) + PI;
 float d = r - a + PI2;
 float n = floor(d/PI2);
 d = d - n*PI2;
 float dd = (d < PI*2.9) ? 0.1 : 0.0;
 float da = a + n*PI2;
 float pos = da*da*.07 - time*1.3;
 vec3 norm = BALL_SIZE * vec3(fract(pos) - .5, d / PI2 - .5, 1.);
 float len = length(norm.xy);
 vec3 color = vec3(0.1, 0.1, 0.0);  // background
 if(len <= 1.0)   // hit sphere ?
 {
  norm.z = sqrt(1.0 - len*len);
  vec3 lightdir = normalize(vec3(-0.0, -1.0, 1.0));
  dd = dot(lightdir, norm);
  dd = max(dd, 0.1);
  float rand = sin(floor(pos));
  color.rgb = dd*fract(rand*vec3(10.0, 1000.0, 100000.0));
  vec3 halfv = normalize(lightdir + vec3(0.0, 0.0, 1.0));
  float spec = dot(halfv, norm);
  spec = max(spec, 0.0);
  spec = pow(spec, 40.0);
  color += spec*vec3(3.0, 1.0, 1.0);
 }
 gl_FragColor.rgba = vec4(color, 1.0);
}