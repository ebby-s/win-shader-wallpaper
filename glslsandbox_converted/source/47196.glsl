/*
 * Original shader from: https://www.shadertoy.com/view/MsGczV
 */

#ifdef GL_ES
  precision mediump float;
#endif

// glslsandbox uniforms
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

// shadertoy globals
float iTime;
vec3  iResolution;

// --------[ Original ShaderToy begins here ]---------- //

// Inspired by:
//  http://cmdrkitten.tumblr.com/post/172173936860

#define TAU 6.283185307179586
#define Pi (mod(time/50.0, TAU))

vec2 uv = vec2(0.0);
float eps = 0.01;

// Scene parameters;
const float count = 3.0;
float t = 0.0;
vec3 base = vec3(0.95, 0.7, 0.3);

struct Gear
{
    float t;   // Time
    float gearR;  // Gear radius
    float teethH;  // Teeth height
    float teethR;  // Teeth \"roundness\"
    float teethCount; // Teeth count
    float diskR;  // Inner or outer border radius
    vec3 color;   // Color
};
    
float GearFunction(vec2 uv, Gear g)
{
    float r = length(uv);
    float a = atan(uv.y, uv.x);
    
    // Gear polar function:
    //  A sine squashed by a logistic function gives a convincing
    //  gear shape!
    float p = g.gearR-0.5*g.teethH + 
              g.teethH/(1.0+exp(g.teethR*sin(g.t + g.teethCount*a)));

    float gear = r - p;
    float disk = r - g.diskR;
    
    return g.gearR > g.diskR ? max(-disk, gear) : max(disk, -gear);
}

float GearDe(vec2 uv, Gear g)
{
    // IQ's f/|Grad(f)| distance estimator:
    float f = GearFunction(uv, g);
    vec2 eps = vec2(0.0001, 0);
    vec2 grad = vec2(
        GearFunction(uv + eps.xy, g) - GearFunction(uv - eps.xy, g),
        GearFunction(uv + eps.yx, g) - GearFunction(uv - eps.yx, g)) / (2.0*eps.x);
    
    return (f)/length(grad);
}

float GearShadow(vec2 uv, Gear g)
{
    float r = length(uv+vec2(0.1));
    float de = r - g.diskR + 0.0*(g.diskR - g.gearR);
    float eps = 0.4*g.diskR;
    return smoothstep(eps, 0., abs(de));
}

void DrawGear(inout vec3 color, vec2 uv, Gear g, float eps)
{
    float d = smoothstep(eps, -eps, GearDe(uv, g));
    float s = 1.0 - 0.7*GearShadow(uv, g);
    color = mix(s*color, g.color, d);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float t = 0.5*iTime;
    vec2 uv = 2.0*(fragCoord - 0.5*iResolution.xy)/iResolution.y;
    float eps = 2.0/iResolution.y;

    // Scene parameters;
    vec3 base = vec3(0.95, 0.7, 0.2);
    const float count = 3.0;

    Gear outer = Gear(1.1, 0.8, 0.08, 4.0, 32.0, 0.9, base);
    Gear inner = Gear(0.0, 1.1, 0.2,  4.0, 16.0, 0.9, base);
    
    vec3 color = vec3(0.0);
    
    // Draw outer gear:
    DrawGear(color, uv, inner, eps);
    DrawGear(color, uv, outer, eps);

    // Draw inner gears back to front:
    for(float i=0.0; i<count; i++)
    {
        vec2 reluv = 2.75*(uv+0.4*vec2(cos(t),sin(t)));
     
        t /= 2.2*Pi/count;
        inner.t =    16.0*t+10.5;
        outer.t = 2.*16.0*t+10.5;
        inner.color = base*(0.35 + 0.6*i/(count-1.0));
     DrawGear(color, reluv, outer, eps);
        DrawGear(color, reluv, inner, eps);
     
    // Draw inner gears back to front:
    for(float j=0.0; j<count; j++)
    {
        vec2 reluv = 2.75*(reluv+0.4*vec2(cos(t),sin(t)));
        t += (2.0 + TAU-Pi)*Pi/count;
        inner.t = 3.   *16.0*t+14.5;
        outer.t = 3.*2.*16.0*t+10.5;
        inner.color = base*(0.35 + 0.6*j/(count-1.0));
     DrawGear(color, reluv, outer, eps);
        DrawGear(color, reluv, inner, eps);
     
    // Draw inner gears back to front:
    for(float k=0.0; k<count; k++)
    {
        vec2 reluv = 2.75*(reluv+0.4*vec2(cos(t),sin(t)));
        t += 2.0*Pi/count;
        inner.t = 3.   *16.0*t+14.5;
        outer.t = 3.*2.*16.0*t+10.5;
        inner.color = base*(0.35 + 0.6*k/(count-1.0));
     DrawGear(color, reluv, outer, eps);
        DrawGear(color, reluv, inner, eps);
     
      inner.t = 0.;
      outer.t = 0.;
    }
      inner.t = 0.;
      outer.t = 0.;
    }
      inner.t = 0.;
      outer.t = 0.;
    }
    
    fragColor = vec4(color,1.0);
}

// --------[ Original ShaderToy ends here ]---------- //

void main(void)
{
    iTime = time;
    iResolution = vec3(resolution, 0.0);
    mainImage(gl_FragColor, gl_FragCoord.xy);
}
