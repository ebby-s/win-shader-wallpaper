// added mouse handling..

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
 
 vec2 pos = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5,0.5); 
        float horizon = -0.3*cos(mouse.y*10.0/3.0); 
        float fov = 0.6; 
 float scaling = 0.61;
 
 vec3 p = vec3(pos.x, fov, pos.y - horizon);
 float a = -mouse.x*0.1*time;
 vec3 q = vec3(p.x*cos(a)+p.y*sin(a), p.x*sin(a)-p.y*cos(a),p.z);
 vec2 s = vec2(q.x/q.z, q.y/q.z) * scaling;

 //checkboard texture
 float color = sign((mod(s.x, 0.1) - 0.05) * (mod(s.y, 0.1) - 0.05)); 
 //fading
 color *= p.z*p.z*(8.0+2.0*sin(time*3.));
 
 gl_FragColor = vec4( color*vec3(1.0, s.x, s.y), 1.0 );
}