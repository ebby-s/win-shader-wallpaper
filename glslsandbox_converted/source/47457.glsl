#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = 3.14159;

vec2 circle(float radius, float f0) {
 float time = time;
 return vec2(radius * sin(time + f0), radius * cos(time + f0));
}

float get_circle_color(vec2 position, float f0){
 vec2 center = vec2(0.5);
 return clamp(0.0, 1.0, distance(position, center + circle(0.2, f0)) * 1.7);
}

void main( void ) {
 
 vec2 position = ( gl_FragCoord.xy / resolution.xy ) /* + mouse / 4.0 */; 
 
 // position.x = pow(position.x, 2.0);

 vec3 color;
 color.r = 1.0 - get_circle_color(position, 0.0 * pi / 3.0 * sin(time));
 color.g = 1.0 - get_circle_color(position, 2.0 * pi / 3.0 * sin(time));
 color.b = 1.0 - get_circle_color(position, 4.0 * pi / 3.0 * sin(time));

 gl_FragColor = vec4( color, 1.0 );

}