#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define EPS 0.001
#define STEPS 128
#define FAR  100.
#define KIFS   30

mat2 rot( float a )
{

 return mat2( cos( a ), -sin( a ),
       sin( a ),  cos( a )
     );

}

float map( vec3 p )
{

 mat3 rota = mat3( 1.0 );
 
 for( int i = 0; i < KIFS; ++i )
 {
 
  p = abs( p * rota - vec3( 0.1, 0.0, 0.0 ) );
  p.xy = p.yx;
  
  p.xz *= rot( 1.0 + mouse.x );
  p.yx *= rot( 2.0 + mouse.y );
 
 }
 
 return 1.0 - length( p ); 

}

vec3 norm( vec3 p )
{

 vec2 e = vec2( EPS, 0.0 );
 return normalize( vec3( map( p + e.xyy ) - map( p - e.xyy ),
           map( p + e.yxy ) - map( p - e.yxy ),
           map( p + e.yyx ) - map( p - e.yyx )
         )
   );

}

float ray( vec3 ro, vec3 rd, out float d )
{

 float t = 0.0; d = 0.0;
 
 for( int i = 0; i < STEPS; ++i )
 {
 
  d = map( ro + rd * t );
  if( d < EPS || t > FAR ) break;
  
  t += d;
 
 }
 
 return t;

}

vec3 shad( vec3 ro, vec3 rd )
{

 float d = 0.0, t = ray( ro, rd, d );
 vec3 p = ro + rd * t;
 vec3 n = norm( p );
 vec3 lig = normalize( vec3( sin( time ), 1.0, cos( time ) ) );
 vec3 ref = reflect( rd, n );
 vec3 col = vec3( 0 );
 
 float amb = 0.5 + 0.5 * n.y;
 float dif = max( 0.0,  dot( lig, n ) );
 float spe = pow( clamp( dot( ref, lig ), 0.0, 1.0 ), 16.0 );
 
 col += 0.8 * amb;
 col += 0.2 * dif;
 col += 0.4 * spe;
 
 return col;

}

void main( void ) {

 vec2 uv = ( -resolution.xy + 2.0 * gl_FragCoord.xy ) / resolution.y;

 vec3 ro = vec3( 0.0, 0.0, 2.4 );
 vec3 ww = normalize( vec3( 0 ) - ro );
 vec3 uu = normalize( cross( vec3( 0, 1, 0 ), ww ) );
 vec3 vv = normalize( cross( ww, uu ) );
 vec3 rd = normalize( uv.x * uu + uv.y * vv + 1.5 * ww );
 
 //vec3 rd = normalize( vec3( uv, -1.0 ) );
 
 float d = 0.0, t = ray( ro, rd, d );
 
 vec3 col = d < EPS ? shad( ro, rd ) : vec3( 0.0 );

 gl_FragColor = vec4( vec3( col ), 1.0 );

}