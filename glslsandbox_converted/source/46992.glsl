precision lowp float;

uniform float time;

uniform vec2 resolution;

const float count = 7.0;

float Hash( vec2 p, in float s ){
    return fract(sin(dot(vec3(p.xy,10.0 * abs(sin(s))),vec3(27.1,61.7, 12.4)))*271758.5453123);
}

float noise(in vec2 p, in float s)
{
    vec2 i = floor(p);
    vec2 f = fract(p);
    f *= f * (3.0-2.0*f);
    return mix(mix(Hash(i + vec2(0.,0.), s), Hash(i + vec2(1.,0.), s),f.x),mix(Hash(i + vec2(0.,1.), s), Hash(i + vec2(1.,1.), s),f.x),f.y) * s;
}

float fbm(vec2 p)
{
     float v = 0.0;
     v += noise(p*1., sin(time));
     v += noise(p*2., sin(time));
     v += noise(p*4., sin(time));
     v += noise(p*8., sin(time));
     return v;
}

void main( void ) 
{

 vec2 uv = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
 uv.x *= resolution.x/resolution.y;

 vec3 finalColor = vec3( 0.0 );
 
  float t = abs(1.0 / ((uv.y + fbm( uv + time)) * 5.0));
  finalColor +=  t * vec3( sin(time) + sin(time), sin(time + 2.0), sin(time + 4.0) );
 
 
 gl_FragColor = vec4( finalColor, 2.0 );

}