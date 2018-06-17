{"code": "/*\n * Original shader from: https://www.shadertoy.com/view/MsGczV\n */\n\n#ifdef GL_ES\n  precision mediump float;\n#endif\n\n// glslsandbox uniforms\nuniform float time;\nuniform vec2 resolution;\nuniform vec2 mouse;\n\n// shadertoy globals\nfloat iTime;\nvec3  iResolution;\n\n// --------[ Original ShaderToy begins here ]---------- //\n\n// Inspired by:\n//  http://cmdrkitten.tumblr.com/post/172173936860\n\n#define TAU 6.283185307179586\n#define Pi (mod(time/50.0, TAU))\n\nvec2 uv = vec2(0.0);\nfloat eps = 0.01;\n\n// Scene parameters;\nconst float count = 3.0;\nfloat t = 0.0;\nvec3 base = vec3(0.95, 0.7, 0.3);\n\nstruct Gear\n{\n    float t;\t\t\t// Time\n    float gearR;\t\t// Gear radius\n    float teethH;\t\t// Teeth height\n    float teethR;\t\t// Teeth \"roundness\"\n    float teethCount;\t// Teeth count\n    float diskR;\t\t// Inner or outer border radius\n    vec3 color;\t\t\t// Color\n};\n    \nfloat GearFunction(vec2 uv, Gear g)\n{\n    float r = length(uv);\n    float a = atan(uv.y, uv.x);\n    \n    // Gear polar function:\n    //  A sine squashed by a logistic function gives a convincing\n    //  gear shape!\n    float p = g.gearR-0.5*g.teethH + \n              g.teethH/(1.0+exp(g.teethR*sin(g.t + g.teethCount*a)));\n\n    float gear = r - p;\n    float disk = r - g.diskR;\n    \n    return g.gearR > g.diskR ? max(-disk, gear) : max(disk, -gear);\n}\n\nfloat GearDe(vec2 uv, Gear g)\n{\n    // IQ's f/|Grad(f)| distance estimator:\n    float f = GearFunction(uv, g);\n    vec2 eps = vec2(0.0001, 0);\n    vec2 grad = vec2(\n        GearFunction(uv + eps.xy, g) - GearFunction(uv - eps.xy, g),\n        GearFunction(uv + eps.yx, g) - GearFunction(uv - eps.yx, g)) / (2.0*eps.x);\n    \n    return (f)/length(grad);\n}\n\nfloat GearShadow(vec2 uv, Gear g)\n{\n    float r = length(uv+vec2(0.1));\n    float de = r - g.diskR + 0.0*(g.diskR - g.gearR);\n    float eps = 0.4*g.diskR;\n    return smoothstep(eps, 0., abs(de));\n}\n\nvoid DrawGear(inout vec3 color, vec2 uv, Gear g, float eps)\n{\n    float d = smoothstep(eps, -eps, GearDe(uv, g));\n    float s = 1.0 - 0.7*GearShadow(uv, g);\n    color = mix(s*color, g.color, d);\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n    float t = 0.5*iTime;\n    vec2 uv = 2.0*(fragCoord - 0.5*iResolution.xy)/iResolution.y;\n    float eps = 2.0/iResolution.y;\n\n    // Scene parameters;\n    vec3 base = vec3(0.95, 0.7, 0.2);\n    const float count = 3.0;\n\n    Gear outer = Gear(1.1, 0.8, 0.08, 4.0, 32.0, 0.9, base);\n    Gear inner = Gear(0.0, 1.1, 0.2,  4.0, 16.0, 0.9, base);\n    \n    vec3 color = vec3(0.0);\n    \n    // Draw outer gear:\n    DrawGear(color, uv, inner, eps);\n    DrawGear(color, uv, outer, eps);\n\n    // Draw inner gears back to front:\n    for(float i=0.0; i<count; i++)\n    {\n        vec2 reluv = 2.75*(uv+0.4*vec2(cos(t),sin(t)));\n\t    \n        t /= 2.2*Pi/count;\n        inner.t =    16.0*t+10.5;\n        outer.t = 2.*16.0*t+10.5;\n        inner.color = base*(0.35 + 0.6*i/(count-1.0));\n    \tDrawGear(color, reluv, outer, eps);\n        DrawGear(color, reluv, inner, eps);\n\t    \n    // Draw inner gears back to front:\n    for(float j=0.0; j<count; j++)\n    {\n        vec2 reluv = 2.75*(reluv+0.4*vec2(cos(t),sin(t)));\n        t += (2.0 + TAU-Pi)*Pi/count;\n        inner.t = 3.   *16.0*t+14.5;\n        outer.t = 3.*2.*16.0*t+10.5;\n        inner.color = base*(0.35 + 0.6*j/(count-1.0));\n    \tDrawGear(color, reluv, outer, eps);\n        DrawGear(color, reluv, inner, eps);\n\t    \n    // Draw inner gears back to front:\n    for(float k=0.0; k<count; k++)\n    {\n        vec2 reluv = 2.75*(reluv+0.4*vec2(cos(t),sin(t)));\n        t += 2.0*Pi/count;\n        inner.t = 3.   *16.0*t+14.5;\n        outer.t = 3.*2.*16.0*t+10.5;\n        inner.color = base*(0.35 + 0.6*k/(count-1.0));\n    \tDrawGear(color, reluv, outer, eps);\n        DrawGear(color, reluv, inner, eps);\n\t    \n      inner.t = 0.;\n      outer.t = 0.;\n    }\n      inner.t = 0.;\n      outer.t = 0.;\n    }\n      inner.t = 0.;\n      outer.t = 0.;\n    }\n    \n    fragColor = vec4(color,1.0);\n}\n\n// --------[ Original ShaderToy ends here ]---------- //\n\nvoid main(void)\n{\n    iTime = time;\n    iResolution = vec3(resolution, 0.0);\n    mainImage(gl_FragColor, gl_FragCoord.xy);\n}\n", "user": "66092fd", "parent": "/e#46939.4", "id": 47196}