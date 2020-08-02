#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// Bonzomatic's default shader translated to glsl sandbox format


float fGlobalTime = time; // in seconds
vec2 v2Resolution = resolution; // viewport resolution (in pixels)

vec4 out_color;
           
vec4 plas( vec2 v, float time )
{
      float c = 0.5 + sin( v.x * 10.0 ) + cos( sin( time + v.y ) * 20.0 );
      return vec4( sin(c * 0.2 + cos(time)), c * 0.15, cos( c * 0.1 + time / .5) * .25, 1.0 );
}

void main(void)
{
      vec2 uv = vec2(gl_FragCoord.x / v2Resolution.x, gl_FragCoord.y / v2Resolution.y);
      uv -= 0.5;
      uv /= vec2(v2Resolution.y / v2Resolution.x, 1);
    
      vec2 m;
      m.x = atan(uv.x / uv.y) / 3.14;
      m.y = 1. / length(uv) * .2;
      float d = min(m.y, length(uv.y));
    
      float f = sin(time*3.) * .2 + sin(mod(mouse.y * 5., 1.) + mod(mouse.x * 19., 2.0)) * 0.2; // texture( texFFT, d ).r * 100.;
      m.x += sin( time) * 0.1;
      m.y += min((time * 0.0001), time-d);
    
      vec4 t = plas( m * 3.14, time-m.y ) / d;
      t = clamp( t-(d*sin(time)), 0.1, 1.0 );
      out_color = f + t;
  
      gl_FragColor = out_color;
}