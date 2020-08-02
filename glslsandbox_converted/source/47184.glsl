#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float width;
float height;
float centerX;
float centerY;
const int BALL_NUM = 600;

vec3 drawBall( int n, float size, float subOffset ) {
 float offset = float(n) * ( 8.14 * 8.0 / float(BALL_NUM) ) + subOffset;
 float x = centerX * ( 1.0 + cos( 1.9 * time + offset ) );
 float y = centerY * ( 1.0 + sin( 1.2 * time + offset ) * sin(time/1.5) );
 
 vec2 center = vec2( x, y );
 
 vec3 color = vec3( 23.0, 60.0, 100.0 );
 
 vec2 pos = gl_FragCoord.xy;
 //pos = center + mod( pos, 50.0 ) - 25.0;
 float dist = length( pos - center );
 color = vec3( pow( size / dist, 2.0 ) );
 return color;
}

void main( void ) {

 width = resolution.x;
 height = resolution.y;
 centerX = width / 2.0;
 centerY = height / 2.0;
 
 vec3 color = vec3(0.0);
 for( int i = 0; i < BALL_NUM; ++i ) {
  color += drawBall( i, 2.0, 0.0 );
 }
 
 gl_FragColor = vec4( color, 1.0 );
}