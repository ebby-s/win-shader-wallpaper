//by Zanple
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define CHAR_SIZE vec2(6, 7)
#define CHAR_SPACING vec2(6, 9)

#define DOWN_SCALE 2.0

vec2 res = resolution.xy / DOWN_SCALE;
vec2 start_pos = vec2(0);
vec2 print_pos = vec2(0);
vec2 print_pos_pre_move = vec2(0);
vec3 text_color = vec3(1);


#define HEX(i) text_color = mod(vec3(i / 65536,i / 256,i),vec3(256.0))/255.0;
#define RGB(r,g,b) text_color = vec3(r,g,b);

#define STRWIDTH(c) (c * CHAR_SPACING.x)
#define STRHEIGHT(c) (c * CHAR_SPACING.y)
#define BEGIN_TEXT(x,y) print_pos = floor(vec2(x,y)); start_pos = floor(vec2(x,y));


#define _ col+=char(vec2(0.0,0.0),uv);
#define _exc col+=char(vec2(276705.0,32776.0),uv)*text_color;
#define _C col+=char(vec2(935172.0,133276.0),uv)*text_color;
#define _E col+=char(vec2(2048263.0,1181758.0),uv)*text_color;
#define _F col+=char(vec2(2048263.0,1181728.0),uv)*text_color;
#define _M col+=char(vec2(1142100.0,665762.0),uv)*text_color;
#define _O col+=char(vec2(935188.0,665756.0),uv)*text_color;
#define _P col+=char(vec2(1983767.0,1181728.0),uv)*text_color;
#define _R col+=char(vec2(1983767.0,1198242.0),uv)*text_color;
#define _Y col+=char(vec2(1131794.0,1081864.0),uv)*text_color;


float extract_bit(float n, float b)
{
 b = clamp(b,-1.0,22.0);
 return floor(mod(floor(n / pow(2.0,floor(b))),2.0));   
}

float sprite(vec2 spr, vec2 size, vec2 uv)
{
 uv = floor(uv+50.);
 float bit = (size.x-uv.x-1.0) + uv.y * size.x;  
 bool bounds = all(greaterThanEqual(uv,vec2(0)))&& all(lessThan(uv,size)); 
 return bounds ? extract_bit(spr.x, bit - 21.0) + extract_bit(spr.y, bit) : 0.0;
}

vec3 char(vec2 ch, vec2 uv)
{
 float px = sprite(ch, CHAR_SIZE, uv - print_pos);
 print_pos.x += CHAR_SPACING.x;
 return vec3(px);
}


vec3 Text(vec2 uv)
{
     vec3 col = vec3(0.0);
     
     vec2 center_pos = vec2(res.x/2.0 - STRWIDTH(10.0)/2.0,res.y/2.0 - STRHEIGHT(1.0)/2.0);
        
     BEGIN_TEXT(center_pos.x,center_pos.y)
 HEX(0xFFFFF) _ _ _ _ _ _ _ _ _F _O _R _ _M _Y _ _P _E _C _Y _exc
 
 BEGIN_TEXT(res.x/2.0-STRWIDTH(11.0)/2.0,res.y/2.0)
 print_pos += vec2(cos(time)*96.,sin(time)*96.);
 
    
     return col;
}

void main( void )
{
 vec2 uv = gl_FragCoord.xy / DOWN_SCALE;
 vec2 duv = floor(gl_FragCoord.xy / DOWN_SCALE);
    
 vec3 pixel = Text(duv);

 vec3 col = pixel*0.9+0.1;
 col *= (1.-distance(mod(uv,vec2(1.0)),vec2(0.65)))*1.2;
 

 gl_FragColor = vec4(vec3(col), 1.);
vec2 p = (2.0*gl_FragCoord.xy-resolution)/resolution.y;
p -= vec2(0.,0.3);

    float tt = mod(time,2.0)/2.0;
    float ss = pow(tt,.2)*0.5 + 0.5;
    ss -= ss*0.2*sin(tt*6.2831*10.0)*exp(-tt*6.0);
    p *= vec2(0.55,1.5) + ss*vec2(0.5,-0.5);

    
    float a = atan(p.x,p.y)/3.141593;
    float r = length(p);

    float h = abs(a);
    float d = (13.0*h - 22.0*h*h + 10.0*h*h*h)/(6.0-5.0*h);

    float f = step(r,d) * pow(.6-r/d,0.2);
 gl_FragColor += vec4(f,0,f/5.,1.0);
}
 