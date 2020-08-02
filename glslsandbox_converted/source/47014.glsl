#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float plot(vec2 st, float pct){
  return  smoothstep( pct-0.01, pct, st.y+0.01) -
          smoothstep( pct, pct+0.01, st.y);
}

float random (in float x) {
    return fract(sin(x)*1e4);
}

float noise (in float x) {
    float i = floor(x);
    float f = fract(x);

    // Cubic Hermine Curve
    float u = f * f * (3.0 - 2.0 * f);

    return mix(random(i), random(i + 1.), u);
}

void main() {
    vec2 st = gl_FragCoord.xy/resolution.xy;
    st.x *= resolution.x/resolution.y;
    vec3 color = vec3(0.0);

    float y = 1.0;
     //y = random(st.x*0.001+time);
    y = noise(st.x*3.+time)*0.5 + 0.3;

    // color = vec3(y);
    float pct = plot(st,y);
    color = pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color,1.0);
}

