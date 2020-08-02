#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 n) { 
 return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float getRandomCircle(vec2 p)
{
 const float tiles = 256.0;
 
 vec2 tilePosition = p * tiles;
 vec2 tileNumber = floor(tilePosition);
 vec2 tileFract = fract(tilePosition)-0.5;
 
 float point = length(tileFract);
       point = smoothstep(0.3, 0.0, point);
        
 float randomValue = rand(tileNumber);
 
 return point * step(randomValue, 0.01);
}

void main( void ) {

 vec2 position = gl_FragCoord.xy / resolution.xy;

 vec3 color = vec3(0.0);
      color += getRandomCircle(position);
 
 gl_FragColor = vec4(color, 1.0 );

}