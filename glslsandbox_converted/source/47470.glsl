#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


//return the direction of ray
//vec3 generate_camera_ray(position){}

void main( void ) {
 vec2 position = (gl_FragCoord.xy * 2.0 - resolution); 
 //ray = generate_camera_ray(position);
 //gl_FragColor = vec4(position.x/resolution.x, 0, -position.x/resolution.x, 1);
}