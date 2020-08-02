// test pattern generator for 24 bits visualizer via TFP401A
// channels take turns counting up to 255 or down to 0
// at any given time, one or two channels have active bits
// (or all 3 if you drop the saturation from 1.0)

#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * (mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y));
}

void main( void )
{
 gl_FragColor = vec4( hsv2rgb(vec3(time * 0.005,1.0,1.0)), 1.0 );
}