#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
 
 vec2 pos = (2.0 * gl_FragCoord.xy - resolution.xy) / min(resolution.x, resolution.y);
 pos = cos(time) * pos + sin(time) * pos.yx * vec2(1.0, -1.0);
 
 float dp = dot(pos,pos);
 pos = (dp > 0.1) ? (pos * (1.0-dp)) : (pos / (1.0+dp*dp));
 
        float horizon = 0.0; 
        float fov = 1.4; 
 float scaling = 0.1;
 
 vec3 p = vec3(pos.y, fov, (pos.x - horizon) / (1.55 + 1.5 * sin(time)));      
 vec2 s = vec2(p.x/p.z, p.y/p.z + 8.0 * time * sign(p.z)) * scaling;
 
 //checkboard texture
 float color = sign((mod(s.x, 0.1) - 0.05) * (mod(s.y, 0.1) - 0.05)); 
 //fading
 color *= p.z*p.z*10.0;
 
 gl_FragColor = vec4( vec3(color), 1.0 );

}