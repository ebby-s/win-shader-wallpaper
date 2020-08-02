#version 150

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform vec3 spectrum;

uniform sampler2D texture0;
uniform sampler2D texture1;
uniform sampler2D texture2;
uniform sampler2D texture3;
uniform sampler2D prevFrame;
uniform sampler2D prevPass;
vec4 image;

in VertexData
{
    vec4 v_position;
    vec3 v_normal;
    vec2 v_texcoord;
} inData;

out vec4 fragColor;

void main(void)
{
    vec2 uv = -1. + 2. * inData.v_texcoord;
    image = texture(texture1,inData.v_texcoord);
    fragColor = vec4(
        (1-abs(cos(uv.x*25*mouse.x)-uv.y*tan(2-mouse.y)))*mod(uv.x*200,2),
        //(1-abs(cos(uv.x*25)-uv.y*tan(time/2)))*mod(uv.x*200,2),
        0.,//8-mod(uv.x*200,2),
        //1-abs(cos(uv.x*10)-uv.y*tan(time)),
        0.6-(pow(uv.x,2)+pow(uv.y,2)-0.0144),
        1.0);
        
    fragColor = vec4(
        fragColor.r,
        sqrt(fragColor.r*cos(time)),
        abs(fragColor.b*sin(time)),
        fragColor.a
        );
        
    fragColor = vec4(
    fragColor.r*image.r,
    fragColor.g*image.g,
    fragColor.b*image.b,
    fragColor.a*image.a
    );
}