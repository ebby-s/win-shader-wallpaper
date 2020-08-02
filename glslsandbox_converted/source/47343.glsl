//--- hatsuyuki ---
// by Catzpaw 2016
#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

vec2 calc(vec2 point1, vec2 point2) {
 vec2 off = point1 - point2;
 float k = off.y/off.x;
 float b = point1.y - k * point1.x;
 return vec2(k, b);
}

float color(vec2 point1, vec2 point2, vec2 point3, vec2 point4, vec2 uv) {
 vec2 line1 = calc(point1, point2);
 vec2 line2 = calc(point2, point3);
 vec2 line3 = calc(point3, point4);
 vec2 line4 = calc(point4, point1);
 
 float color = 1. - step(line1.x * uv.x + line1.y, uv.y);
 color *= step(line3.x * uv.x + line3.y, uv.y);
 color *= 1. - step((uv.y - line4.y)/line4.x, uv.x);
 color *= step((uv.y - line2.y)/line2.x, uv.x);
 return color;
}


float circle(float radius, vec2 coord) {
    if (abs(coord.x) > radius || abs(coord.y) > radius) {
        return 1.;
    }
    return smoothstep(radius, radius, length(coord));
}

void main(void){
 vec2 uv=(gl_FragCoord.xy*2.-resolution.xy)/resolution.y; 
 vec3 finalColor=vec3(0);
 // 1
 vec2 point1 = vec2(0.8+ 0.2 * random(vec2(0.,0.) + 0.1) * sin(time - 10.), 0.2 + 0.1 * random(vec2(0.,0.) + 0.2)  * sin(time - 20.));
 // 4
 vec2 point4 = vec2(0.8 + 0.2 * random(vec2(0.,0.) + 0.3) * cos(time), -0.2 - 0.1 * random(vec2(0.,0.) + 0.4)  * sin(time*1.));
 // 3
 vec2 point3 = vec2(-0.8 - 0.2 * random(vec2(0.,0.) + 0.5) * sin(time), -0.2 - 0.1 * random(vec2(0.,0.) + 0.6) * cos(time) );
 // 2
 vec2 point2 = vec2(-0.8 - 0.2 * random(vec2(0.,0.) + 0.7) * sin(time), 0.5 + 0.1 * random(vec2(0.,0.) + 0.8)  * sin(time));

 
 float c = color(point1, point2, point3, point4, uv);
 vec3 red = vec3(c, 0.,0.);
 vec3 circle = vec3(0.);
 gl_FragColor = vec4(mix(circle, red, 0.5),1);
}
