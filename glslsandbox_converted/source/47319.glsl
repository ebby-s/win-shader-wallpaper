#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi = 3.14159265358979;

vec2 tile(vec2 uv, float size) {
 float prop = sin(pi / 3.0);
 vec2 ret = uv;
 ret.x += fract(floor(uv.y / (size  * prop)) * 0.5 * size);
 ret.x = fract(ret.x / size);
 ret.y = fract(ret.y / (size  * prop)) * prop + abs(1.0 - prop) / 2.0;
 return ret;
}

vec2 tileCenter(vec2 uv, float size) {
 float prop = sin(pi / 3.0);
 vec2 ret = uv;
 ret.x += fract(floor(uv.y / (size  * prop)) * 0.5 * size);
 ret.x = mod(ret.x, size);
 ret.y = mod(ret.y, (size  * prop));
 return uv - ret + (size * vec2(1.0,  prop) * 0.5);
}

void main( void ) {
 
 float px = 1.0 / max(resolution.x, resolution.y);
 vec2 uv = gl_FragCoord.xy * px;
 
 float theta = time * 0.5;
 uv -= resolution * 0.5 * px;
 uv *= mat2(sin(theta), -cos(theta), cos(theta), sin(theta));
 uv += resolution * 0.5 * px;
 
 float tile_size = 0.05;
 float circle_size = 0.05;
 vec2 tile_uv1 = tile(uv, tile_size);
 vec2 tile_uv2 = tileCenter(uv, tile_size);
 
 float mask = smoothstep(circle_size + px * 20.0, circle_size, distance(tile_uv1, vec2(0.5)));
 
 float p = 0.68;

 vec3 col = vec3(tile_uv2, 0.2).xzy * mask * p + vec3(uv, 0.2).xzy * (1.0 - mask) * (1.0 - p);
 
 gl_FragColor = vec4( col, 1.0 );

}