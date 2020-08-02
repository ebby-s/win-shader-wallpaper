//CLEANCODE
#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec4  kRGBToYPrime = vec4 (0.299, 0.587, 0.114, 0.0);
const vec4  kRGBToI     = vec4 (0.596, -0.275, -0.321, 0.0);
const vec4  kRGBToQ     = vec4 (0.212, -0.523, 0.311, 0.0);

const vec4  kYIQToR   = vec4 (1.0, 0.956, 0.621, 0.0);
const vec4  kYIQToG   = vec4 (1.0, -0.272, -0.647, 0.0);
const vec4  kYIQToB   = vec4 (1.0, -1.107, 1.704, 0.0);

varying vec4 vertTexCoord;
uniform sampler2D texture;
uniform float hue;


void main( void ) {
 vec2 texCoord = (gl_FragCoord.xy / resolution.xy+0.15);
 texCoord += sin(texCoord.x * 6. +time) *0.1;
 texCoord += sin(texCoord.y * 0.01 +time) *0.001;
 
 for(float f = 0.0; f < 1000.0; f+=0.1) {
  if(texCoord.y > f/1000.0) {
   gl_FragColor = vec4(cos((1000.0-f)/1000.0), tan((1000.0-f)/1000.0), cos((1000.0-f)/1000.0), 1.0/time);
  }
 }
}