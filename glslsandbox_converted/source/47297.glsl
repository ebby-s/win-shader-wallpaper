/*
Author: Leon Miura
E-mail: (myfullname)@gmail.com
Title: Pac-man shader
Date: August 2012
Note: Comments and variable names in Spanish
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 //---FRAGMENTO ACTUAL---
 vec2 position = gl_FragCoord.xy;
 
 //---COLOR DE FONDO--- 
 gl_FragColor = vec4(0.4,0.8,1.0,1.0);
 
 
 //---PAC-DOTS--- (los puntos que pacman se come)
 float rpd = 3.0;  //radio de los pac-dots
 vec4 colorpd = vec4( 1.0,1.0,1.0, 1.0);
 float radio_brillo = 5.0; //radio del brillo alrededor de los pac-dots
 float decaimiento;  // o atenuaci\u00f3n del brillo de los pac-dots
 const int NUM_PAC_DOTS = 7; //cantidad de pac-dots
 vec2 pac_dots_pos[NUM_PAC_DOTS];//array de posiciones de los pac-dots
 vec2 posicion_p1;  //posici\u00f3n del primer pac-dot
 posicion_p1.x = resolution.x / 4.0;
 posicion_p1.y = resolution.y/2.0;
 float dist_puntos = 80.0; //distancia horizontal entre pac-dots consecutivos

 
 //---FANTASMA---
 vec2 pos_fantasma;
 pos_fantasma.x = resolution.x * 0.75;
 pos_fantasma.y = resolution.y/2.0 + sin(time * 1.5) * 100.0;
 float radio_fantasma = 20.0;
 float entre_ojos_fantasma = 7.0;
 float radio_ojos_fantasma = 5.0;
 float radio_pupilas_fantasma = 2.0;
 vec4 color_blanco = vec4(1.0,1.0,1.0,1.0);
 vec4 color_fantasma = vec4(1.0,0.0,0.0,1.0);
 vec4 color_pupilas_fantasma = vec4(0.0,0.0,1.0,1.0);

 
 //---PISTA---
 float ancho_calle = 60.0;
 float ancho_pared = 1.1;
 vec4 color_pared = vec4(1.0,1.0,1.0,1.0);
 vec4 color_calle = vec4(0.3,0.7,0.1,1.0);
 float calle_horizontal_y = resolution.y/2.0;
 float calle_vertical_x   = resolution.x * 0.75;
 
 
 //---PAC-MAN---
 vec4 color_pacman = vec4(0.9,0.9,0.0,1.0);
 float radio_pacman = 20.0;
 float angulo;   //de apertura de la boca
 float variacion_angulo = 0.30 * sin(time * 12.0) + 0.3; //angulo base + oscilaci\u00f3n + apertura adicional
 vec2 centro;   //de pacman
 vec2 horizontal = vec2(1.0,0.0);//vector horizontal (1,0)
 int direccion = 0;  //de movimiento de pacman (0: derecha, 1:izquierda)
 float oscilacion = time * 1.5;  //de movimiento horizontal

 centro.x = resolution.x/2.0 + sin(oscilacion) * 300.0; //poner a pacman en el centro horizontal de la pantalla y aplicar oscilaci\u00f3n sinusoidal
 centro.y = resolution.y/2.0;    //poner a pacman en el centro vertical de la pantalla
 
 vec2 orientacion = normalize(position - centro); //pone la boca hacia la izquierda o derecha

 
 //---DEFINIR DIRECCI\u00d3N DE MOVIMIENTO Y ORIENTACI\u00d3N DE PACMAN---
 //la derivada de la coordenada x de pacman nos dice si \u00e9sta va aumentando o disminuyendo
 //si aumenta, la direcci\u00f3n es \"derecha\" (0); si disminuye, es \"izquierda\" (1)
 //(la derivada de sin(x)) = cos(x)
 if(cos(oscilacion) < 0.0)
 {
  direccion = 1;
 }
 
 if(direccion == 1)
 {
  orientacion.xy *= -1.0;
 }

  
 angulo = acos(dot(horizontal, orientacion)); //\u00e1ngulo de apertura de la boca


 
 //---DIBUJAR CALLES---
 //calle horizontal
 if((position.y > calle_horizontal_y - ancho_calle/2.0) &&
    (position.y < calle_horizontal_y + ancho_calle/2.0))
 {
  gl_FragColor = color_calle;
 }

 //calle vertical
 if((position.x > calle_vertical_x - ancho_calle/2.0 + ancho_pared) && 
    (position.x < calle_vertical_x + ancho_calle/2.0))
 {
  gl_FragColor = color_calle;
 }

 
 //---DIBUJAR PAREDES---
 //paredes horizontales
 if(((position.y - ancho_calle/2.0 > calle_horizontal_y && position.y - ancho_calle/2.0  < calle_horizontal_y + ancho_pared) ||
    (position.y + ancho_calle/2.0 > calle_horizontal_y && position.y + ancho_calle/2.0  < calle_horizontal_y + ancho_pared)) &&
    ((position.x < calle_vertical_x - ancho_calle/2.0) || (position.x > calle_vertical_x + ancho_calle/2.0)))
 {
  gl_FragColor = color_pared; 
 }
 
 //paredes verticales
 if(((position.x > calle_vertical_x - ancho_calle/2.0  && position.x < calle_vertical_x - ancho_calle/2.0 + ancho_pared) ||
    (position.x > calle_vertical_x + ancho_calle/2.0  && position.x < calle_vertical_x + ancho_calle/2.0 + ancho_pared)) && 
    ((position.y > calle_horizontal_y + ancho_calle/2.0) || (position.y < calle_horizontal_y - ancho_calle/2.0 + ancho_pared)))
 {
  gl_FragColor = color_pared; 
 }
 
 
 
 
 //---DIBUJAR PAC-MAN---
 if((distance(position,centro) < radio_pacman) && angulo > variacion_angulo)
 {
  gl_FragColor = color_pacman;
 }


 //DIBUJAR PAC-DOTS
 for(int i = 0; i < NUM_PAC_DOTS; i++)
 {
  //establecer posici\u00f3n del pac-dot i
  pac_dots_pos[i].x = posicion_p1.x + float(i) * dist_puntos;
  pac_dots_pos[i].y = resolution.y / 2.0;


  //dibujar el pac-dot i
  if((direccion == 0) && (centro.x < pac_dots_pos[i].x - radio_pacman/2.0) && (distance(position,pac_dots_pos[i]) < rpd + radio_brillo))
  {
   //dibujar el n\u00facleo del pac-dot i
   if(distance(position,pac_dots_pos[i]) < rpd)
   {
    gl_FragColor = colorpd;//vec4( 1.0,1.0,sin(time * 20.0), 1.0);
   }
   
   //dibujar el brillo del pac-dot i
   decaimiento = exp(distance(position,pac_dots_pos[i])/1.5); //decaimiento o atenuaci\u00f3n exponencial del brillo
   gl_FragColor += vec4( 10.0/decaimiento,10.0/decaimiento,sin(time * 20.0)/decaimiento, 10.0/decaimiento);  
  }
 }
 

 //---DIBUJAR EL FANTASMA---
 //dibujar el cuerpo del fantasma
 if(((distance(position,pos_fantasma) < radio_fantasma) || 
    (position.y < pos_fantasma.y && position.x > pos_fantasma.x - radio_fantasma && (position.x < pos_fantasma.x + radio_fantasma))) &&
    (position.y > pos_fantasma.y - radio_fantasma - sin(position.x * 0.75) * 2.0 ))
 {
  gl_FragColor = color_fantasma;
 }
 
 //dibujar en fondo de los ojos del fantasma
 vec2 pos_ojo_izq;
 pos_ojo_izq.x = pos_fantasma.x - entre_ojos_fantasma;
 pos_ojo_izq.y = pos_fantasma.y + 6.0;
 
 vec2 pos_ojo_der;
 pos_ojo_der.x = pos_fantasma.x + entre_ojos_fantasma;
 pos_ojo_der.y = pos_fantasma.y + 6.0;
 
 
 if(distance(position,pos_ojo_izq) < radio_ojos_fantasma)
 {
  gl_FragColor = color_blanco;
 }
 
 if(distance(position,pos_ojo_der) < radio_ojos_fantasma)
 {
  gl_FragColor = color_blanco;
 }
 
 //dibujar las pupilas del fantasma
 vec2 pos_pup_izq;
 pos_pup_izq.x = pos_fantasma.x - entre_ojos_fantasma;
 pos_pup_izq.y = pos_fantasma.y + 9.0;
 
 vec2 pos_pup_der;
 pos_pup_der.x = pos_fantasma.x + entre_ojos_fantasma;
 pos_pup_der.y = pos_fantasma.y + 9.0;
 
 if(distance(position,pos_pup_izq) < radio_pupilas_fantasma)
 {
  gl_FragColor = color_pupilas_fantasma;
 }
 
 if(distance(position,pos_pup_der) < radio_pupilas_fantasma)
 {
  gl_FragColor = color_pupilas_fantasma;
 } 
 

}