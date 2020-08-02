#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define iter 100.0
#define radius 1.0
#define scale 4.0

vec3 malden ( vec2 pos ){
 vec2 z = vec2( 0.0, 0.0 );
 vec2 c = vec2(1.33333 * (pos.x - 0.5) * scale ,(pos.y - 0.5) * scale);
 
 for( float x = 0.0; x < iter; x += 1.0 ){
  z = vec2( z.x * z.x - z.y * z.y + c.x,  
     z.y * z.x + z.x * z.y + c.y  );
  
  if((z.x * z.x + z.y * z.y) > 4.0 ){
   return vec3( mod(x*x, 4.0), mod(x/iter, 5.0), mod(x-z.y*z.x, 10.0) );
  }
  
 }
 return vec3( 0.0 );
}

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

 vec3 color = malden( position );
 
 
 gl_FragColor = vec4( color, 1.0 );

}
