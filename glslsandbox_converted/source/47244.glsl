#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

precision mediump float;

uniform sampler2D texture;
uniform vec3 color1;
uniform vec3 replace1;
uniform vec2 outTexCoord;

void main()
{
vec4 pixel = texture2D(texture, outTexCoord);
vec3 eps = vec3(0.16, 0.16, 0.16);

if( all( greaterThanEqual(pixel, vec4(color1 - eps, 1.0)) ) && all( lessThanEqual(pixel, vec4(color1 + eps, 1.0)) ) )
    pixel = vec4(replace1, 1.0);

gl_FragColor = pixel;
}