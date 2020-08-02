#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float wave(vec2 p)
{
 float v = sin(p.x+sin(p.y) + sin(p.y*.43));
 return v*v;
}

const mat2 rot=mat2(.5,.86,-.86,.5);
const float speed = 1.1;

float map(vec2 p)
{
 float v=0.;
 v+=wave(p);
 p.x+=time * speed;p*=rot;
 v+=wave(p);
 p.x+=time* speed * .17;
 p*=rot;
 v+=wave(p);
 v=abs(1.5-v);
 return v;
}

void main( void ) 
{
 vec2 uv=(gl_FragCoord.xy*2.-resolution.xy)/min(resolution.x,resolution.y);
 vec2 p=normalize(vec3(uv.xy,2.3)).xy*10.;p.y+=time*speed*.3;
 float v=map(p);
 gl_FragColor = vec4(v * .7, v * .3 , v * 0.49, 1.0);
}