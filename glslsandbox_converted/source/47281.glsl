#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 fresnel_effect(vec3 base, float roughness, float dt){
    //return base + (1.0 - base) * pow(1.0 - dt, 5.0);
    return base + (1.0 - base) * exp(-dt * 6.0 * (1.0 - roughness)) * (1.0 - roughness * 0.9);
}

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy );

 float fres = fresnel_effect(vec3(0.0), position.x, position.y).r;

 gl_FragColor = vec4(vec3(fres), 1.0);

}