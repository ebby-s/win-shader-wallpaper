{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 resolution;\n\n// Modified version of https://www.shadertoy.com/view/MstXWn\n\n// cd publi http://evasion.imag.fr/~Fabrice.Neyret/flownoise/index.gb.html\n//          http://mrl.nyu.edu/~perlin/flownoise-talk/\n\n// The raw principle is trivial: rotate the gradients in Perlin noise.\n// Complication: checkboard-signed direction, hierarchical rotation speed (many possibilities).\n// Not implemented here: pseudo-advection of one scale by the other.\n\n// --- Perlin noise by inigo quilez - iq/2013   https://www.shadertoy.com/view/XdXGW8\nvec2 hash(vec2 p)\n{\n\tp = vec2(dot(p,vec2(127.1, 311.7)),\n\t         dot(p,vec2(269.5, 183.3)));\n\n\treturn 2.0 * fract(sin(p) * 43758.5453123) - 1.0;\n}\n\nfloat noise(vec2 p, float t)\n{\n   \tvec2 i = floor(p);\n   \tvec2 f = fract(p);\n\t\n//\tvec2 u = f;\n//\tvec2 u = f * f * (3.0 - 2.0 * f);\n\tvec2 u = f * f * f * (10.0 + f * (6.0 * f - 15.0));\n//\tvec2 u = f * f * f * f * (f * (f * (-20.0 * f + 70.0) - 84.0) + 35.0);\n\n   \tmat2 R = mat2(cos(t), -sin(t), sin(t), cos(t));\n\n\treturn 2.0 * mix(mix(dot(hash(i + vec2(0,0)) * R, (f - vec2(0,0))), \n                             dot(hash(i + vec2(1,0)) * R, (f - vec2(1,0))), u.x),\n                         mix(dot(hash(i + vec2(0,1)) * R, (f - vec2(0,1))), \n                             dot(hash(i + vec2(1,1)) * R, (f - vec2(1,1))), u.x), u.y);\n}\n\nfloat Mnoise(vec2 p, float t) {\n\treturn noise(p, t);\n}\n\nfloat turb(vec2 p, float t) {\n\tfloat f = 0.0;\n \tmat2 m = mat2(1.6,  1.2, -1.2,  1.6);\n \tf  = 0.5000 * Mnoise(p, t); p = m*p;\n\tf += 0.2500 * Mnoise(p, t * -2.1); p = m*p;\n\tf += 0.1250 * Mnoise(p, t * 4.1); p = m*p;\n\tf += 0.0625 * Mnoise(p, t * -8.1); p = m*p;\n\treturn f / .9375; \n}\n\nvoid main( void ) {\n   \tvec2 pos = (2.0 * gl_FragCoord.xy - resolution.xy) / min(resolution.x, resolution.y);\n\t\n  \tfloat f  = turb(1.0 * pos, time);\n\tfloat f2 = turb(1.0 * pos + vec2(0.0, 0.01), time);\n\tfloat f3 = turb(1.0 * pos + vec2(0.01, 0.0), time);\n\tfloat dfdy = (f2 - f) / 0.01;\n\tfloat dfdx = (f3 - f) / 0.01;\n\t//gl_FragColor = vec4(0.5 + 0.5 * f);\n\tgl_FragColor = vec4(0.2 + 0.7 * dot(normalize(vec3(dfdx, dfdy, 1.0)), normalize(vec3(0.0,1.0,1.0))));\n\t//gl_FragColor = mix(vec4(0,0,.3,1), vec4(1.3), vec4(.5 + .5* f)); \n}", "user": "d0b7b1a", "parent": "/e#47159.0", "id": 47165}