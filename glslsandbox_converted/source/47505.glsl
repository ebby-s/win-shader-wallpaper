// test pattern generator for 24 bits visualizer via TFP401A
// snip out chunks from an int and send a scaled float out each channel
// what I see is 24 LEDs counting monotonically in binary
// (works best w/ code hidden and fullscreen, obvs)

#ifdef GL_ES
precision mediump float;
#endif

#extension GL_EXT_gpu_shader4 : enable

uniform float time;

void main(void)
{
 int v = int(fract(time * 0.00001) * 16777216.0);
 int red = (v & 0x00FF0000) >> 16;
 int grn = (v & 0x0000FF00) >> 8;
 int blu = (v & 0x000000FF);
 gl_FragColor = vec4(vec3(float(red), float(grn), float(blu)) / 256.0, 1.0);

}