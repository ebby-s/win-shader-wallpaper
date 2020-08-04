// 240720N - TO FORCE IS WITH YOU! :)

#ifdef GL_ES
precision mediump float;
#endif 

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//uniform sampler2D backbuffer;

float segment(vec2 position, vec2 start_p, vec2 end_p)
{
	vec2 AP = position - start_p;
	vec2 AB = end_p - start_p;
	float h = clamp(dot(AP, AB) / dot(AB, AB), 0.0, 1.0);
	float seg = length(AP - AB * h);
	return seg;
}

void main( void ) {
	vec2 mo = mouse.xy  - vec2(0.025, 0.025);
	vec2 po = (gl_FragCoord.xy / resolution.xy); 
	// po.x += 0.5; po *= 2.0; po /= dot(po,po);
	vec3 c = vec3(po.x, po.y, mo.x);

	vec4 color = vec4(1.0);
	vec2 A = vec2(0.5);
	vec2 B = mo;
	float line_1 = segment(po, A, B);
	vec4 color_1 = color * 0.01 / line_1;
	gl_FragColor = color_1;
	gl_FragColor = clamp(gl_FragColor, 0.0, 10.0);
		
	gl_FragColor += vec4(mo.x+0.5*mo.y, c.r, c.b, 1.0);
}