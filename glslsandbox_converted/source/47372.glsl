precision mediump float;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float segment(vec2 position, vec2 start_p, vec2 end_p)
{
 vec2 AP = position - start_p;
 vec2 AB = end_p - start_p;
 float h = clamp(dot(AP, AB) / dot(AB, AB), 0.0, 1.0);
 float seg = length(AP - AB * h);
 return seg;
}
/*
float segment(vec2 position, vec2 start_p, vec2 end_p)
{
 float seg;
 vec2 AP = position - start_p;
 vec2 AB = end_p - start_p;
 float cos_sita = dot(AP, AB) / (length(AP) * length(AB));
 float dis = dot(AP, AB) / length(AB);
 if(dis <= length(AB) && cos_sita >= 0.0)
  seg = length(AP) * sqrt(1.0 - cos_sita * cos_sita);
 else if (cos_sita < 0.0)
  seg = length(AP);
 else
  seg = length(AP - AB) * 1.0;
 return seg;
}
*/
void main( void ) {
  vec2 uv=(gl_FragCoord.xy/resolution.xy)*2.0-1.0 ;
 
 vec2 position = uv;
 position.x = position.x*(resolution.x / resolution.y) - 0.5;
 vec4 color = vec4(1.0);
 vec2 A = vec2(0.1, -0.0);
 vec2 B = vec2(0.5, 0.5);
 float line_1 = segment(position, A, B);
 vec4 color_1 = color * 0.01 / line_1;
 gl_FragColor = color_1;
 gl_FragColor = clamp(gl_FragColor, 0.0, 1.0);
}