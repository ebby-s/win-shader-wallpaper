#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
    vec2 r = vec2(400,200),
    o = gl_FragCoord.xy *2.0  - r*2.5;
    o = vec2(abs(o.x) / r.y - 2.20, atan(o.y,o.x));
    o *= vec2(abs(o.x) / r.y - .20, atan(o.y,o.x));  
 
    vec4 s = 0.4-cos(time*4.5*vec4(0,3,2,1) + abs(sin(time)+(5.0*time)) + o.y * time + sin(o.y) * cos(time)*4.),
    e = s.yzwx, 
    f = max(o.x-s,e-o.x);
    gl_FragColor = dot(clamp(f*r.y,0.,1.), 72.*(s-e)) * (s-.1) + f;
}