// Mandelbrot/Julia set 
// idea stolen from https://www.shadertoy.com/view/Xs3XWH

#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform vec2 mouse;
uniform vec2 resolution;
uniform float time;

float aspectInv = resolution.y/resolution.x;
const bool drawLine = true;
const bool drawPoints = true;
const float thickness = 1.0/200.0;
const int iterations = 100;
const float bailout = 2.0;

vec2 uvmap(vec2 pixels) {
    vec2 uv = (pixels/resolution)*2.0 - 1.0;
    uv.y *= aspectInv;
    return vec2(uv.y,uv.x);
}

float map(float x, float oldMin, float oldMax, float newMin, float newMax) {
    return newMin + (x - oldMin)/(oldMax - oldMin)*(newMax - newMin);
}

vec2 map(vec2 p, vec2 oldMin, vec2 oldMax, vec2 newMin, vec2 newMax) {
    p.x = map(p.x, oldMin.x, oldMax.x, newMin.x, newMax.x);
    p.y = map(p.y, oldMin.y, oldMax.y, newMin.y, newMax.y);
    return p;
}

float line(vec2 uv, vec2 start, vec2 end) {
    vec2 pa = uv - start;
    vec2 ba = end - start;
    float h = clamp (dot (pa, ba) / dot (ba, ba), 0.0, 1.0);
    float d = length (pa - ba * h);
    
    return 1.0-clamp(d/thickness, 0.0, 1.0);
}

vec2 function(vec2 z, vec2 c) {
    return vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
}

vec4 plot(vec2 z0, vec2 c, bool julia) {
    vec3 set = vec3(0);
    float hue = 0.0;
    vec2 z = z0;
 
    for(int i = 0; i < iterations; i++)
    {
 float absZ = length(z);
 if(absZ > bailout)
 {

     hue /= float(iterations);
     set += vec3(1.);
     break;
 }
 z = function(z, c);
        if(drawPoints) set += line(z0, z, z)/float(iterations);
    }
 
    return vec4(set, 1.0);
}

vec4 plot(vec2 uv, vec2 c) {
    vec3 path = vec3(0);
    vec2 z = vec2(0);
 vec4 color = vec4(1.);
    for(int i = 0; i < iterations; i++)
    {
     if(length(z) > bailout) { color = vec4(vec3(0.),1.); break;}
 vec2 newZ = function(z, c);
 z = newZ;
    }

    return vec4(color);
}
 
void main( void ) {
 
    vec2 uv = uvmap(gl_FragCoord.xy)*2.-vec2(0.5,0.);
    vec2 ms = uvmap(mouse*resolution)-vec2(0.5,0.);

   // ms = map(ms, vec2(-1, -aspectInv), vec2(0, aspectInv), vec2(-2, -2), vec2(2, 2));
 
   // if(uv.x < 0.0)
    {
             gl_FragColor = vec4(vec3(0.),1);
        gl_FragColor -= plot(uv, uv, false);
        gl_FragColor-= vec4(plot(uv, ms, false).x);
    }
 
    if(drawLine) gl_FragColor += plot(uv, ms);
}