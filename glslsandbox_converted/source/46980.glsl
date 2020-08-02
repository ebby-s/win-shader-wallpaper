#ifdef GL_ES
precision highp float;
#endif
#define PI 3.14159265

uniform float time;
uniform vec2 resolution;

float circle( float radius, float fuzzy, vec2 p ) {
 float d = length(p);
 return 1.0 - smoothstep( radius*(1.0-fuzzy), radius*(1.0+fuzzy), d ); 
}

void main( void ) {
 vec2 center = resolution.xy / 2.0;
 vec2 position = gl_FragCoord.xy; 
 vec2 p = (position-center) / resolution.y;
 float d = length(p);
 
 float wipe_angle = mod( time*PI-PI/2.0, PI*2.0 );
 float angle =  mod(  atan( p.y, p.x )-PI/2.0, 2.0*PI);
 
 float RADIUS = 1.0;
 
 float dst = sqrt(position.x * position.x + position.y * position.y);
 float minres = min(resolution.x, resolution.y);
 float pixel = 1.0 / minres;
 
 float radar = circle( RADIUS - 0.5, 0.003, p );
 radar = clamp( radar - smoothstep( wipe_angle, wipe_angle+0.02, angle) , 0.0, 1.0);
 
 gl_FragColor = radar * vec4(1.0, 0.5, 1.0, 1.0);
}