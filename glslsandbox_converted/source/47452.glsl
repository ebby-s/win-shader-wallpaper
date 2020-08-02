#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
 // Bereich beschr\u00e4nken zwischen 0 und 1
 vec2 pos = gl_FragCoord.xy / resolution.x;
 
 // Farbverlauf
 gl_FragColor = vec4(pos.x, 
       1.-pos.x, 
       sin(time), 
       1.
      );
 
 // Objekte nach Mausposition ausrichten
 /*pos.x -= mouse.x;
 pos.y -= mouse.y;
 pos += 0.5;*/
 
 // Quadrat
 /*if( pos.x < 0.6 && pos.x > 0.4 && pos.y > 0.4 && pos.y < 0.6)
 {
  gl_FragColor = vec4(0,
        0,
        0,
    1.
      );
 }*/
 
 // Kreis
 const float tau = 2.0*3.14;
 vec2 origin = vec2(0.25*cos(tau*cos(0.793*time))+0.5,
      0.25*sin(tau*sin(0.1*time))+0.25);
 
 float d = sqrt(pow(pos.x - origin.x, 2.0)+pow(pos.y - origin.y, 2.0));
 
 if (d > 0.25 * 0.3 * sin(time) + 0.1) // GR\u00f6\u00dfe des Kreises
     {
      gl_FragColor = vec4(0.1,
     0.1,
     0.1,
     1
      );
     }
}