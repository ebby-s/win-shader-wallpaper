#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float stripes(float width, float gap, float x) {
    return 1.0 - step(width, mod(x, gap + width));
}

struct Herringbone {
    int factor;
    int gap;
};

float herringbone_half_sample(Herringbone herringbone, vec2 uv) {
    float height = 0.25 / float(herringbone.factor) * 2.0;
    float gap = float(herringbone.gap) / resolution.y;

    float offset = uv.x + uv.y - mod(uv.y, height);

    return stripes(0.5, 0.5, offset)
 * stripes(height - gap, gap, uv.y)
 * stripes(0.5 - gap, gap, offset);

}

vec4 herringbone_sample(Herringbone herringbone, vec2 uv) {
    float mask_1 = herringbone_half_sample(herringbone, uv);
    float mask_2 = herringbone_half_sample(herringbone, uv.yx + vec2(0.5, 0.0));
    return vec4(mask_1 + mask_2, mask_1, mask_2, 1.0);
}

void main() {
    Herringbone herringbone = Herringbone(5, 1);
    gl_FragColor = vec4(herringbone_sample(herringbone, gl_FragCoord.xy / resolution.yy));
}