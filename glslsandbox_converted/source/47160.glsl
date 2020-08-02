#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec3 bgColor = vec3(1.0,0.59,0.4);
bool inCircle(in vec2 point, in vec2 center, in float r){
 vec2 dif = point-center;
 return (dif.x*dif.x) + (dif.y * dif.y) < r*r;
}
bool inRect(in vec2 point, in vec2 pos, in vec2 size){
 return point.x>pos.x && point.x<pos.x+size.x &&
        point.y>pos.y && point.y<pos.y+size.y;
}
bool inRoundRect(in vec2 point, in vec2 pos, in vec2 size, in float r){
 return inRect(point, pos+vec2(0.,r), size - vec2(0.,2.*r)) ||
        inRect(point, pos+vec2(r,0.), size - vec2(2.*r,0.));
}
void main( void ) {
 float maxRadius = max(resolution.x,resolution.y)/4.;
 
 vec3 color = bgColor;
 color *= 
  distance(gl_FragCoord.xy,resolution.xy/2.)<=(maxRadius*mod(time,1.))
  ? (mod(time,1.))
  : 1.;
 gl_FragColor = vec4(color,1.);

}