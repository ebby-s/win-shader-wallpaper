#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec3 blue = vec3(ivec3(255, 255, 0)) / 255.;
const vec3 white = vec3(1, 0, 0);
const vec3 red = vec3(0.0, 0.0, 0.0);
const vec3 pole_color = vec3(0.4, 0.4, 0.4);
const vec3 sky = vec3(0.8, 0.9, 1.0);

bool box(vec2 pos, vec4 bounds) {
 return  ((pos.x >= bounds.x) && (pos.x < bounds.z) && (pos.y >= bounds.y) && (pos.y <= bounds.w)); 
}

vec3 scene(vec2 pos) {
 vec3 color = sky;
 
 color = mix(color, pole_color, float(box(pos, vec4(-12., -20., -12., 10.))));
 color = mix(color, pole_color, float(box(pos, vec4(-13., 8., -11., 9.))));
 
 pos.y += sin(-pos.x / 2. + floor(time * 66.0)) * 1.01;
 
 color = mix(color, red, float(box(pos, vec4(-10000., -6, 10., 6))));
     color = mix(color, white, float(box(pos, vec4(-10000, -6, 10., 1.66)))); 
     color = mix(color, blue, float(box(pos, vec4(-10000., -6, 10., -1.66)))); 
 return color;
}

void main() {
 vec2 uv = (gl_FragCoord.xy) / resolution.xy;
 uv = (uv - 0.5) * 30.0;
 
 vec2 aspect_uv = uv * (resolution.xy / resolution.y);
 vec3 pole = vec3(0.);
 vec2 pixel_uv = floor(aspect_uv * 12.);
 gl_FragColor = vec4(scene(pixel_uv) + pole, 1.0);
}