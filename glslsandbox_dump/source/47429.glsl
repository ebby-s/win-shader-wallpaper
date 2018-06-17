{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n// interactive solar-vixzion by iridule\n\n// https://www.shadertoy.com/view/MsGBDh\n\n// adaptions by i.g.p\n\n#define TWO_PI 6.28318530718\n#define rotate(a) mat2(cos(a), sin(a), -sin(a), cos(a))\n#define spiral(u, a, r, t, d) abs(sin(t + r * length(u) + a * (d * atan(u.y, u.x))))\n#define flower(u, a, r, t) spiral(u, a, r, t, 1.) * spiral(u, a, r, t, -1.)\n#define sinp(a) .5 + sin(a) * .5\n#define polar(a, t) a * vec2(cos(t), sin(t))\n\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord ) \n{\n    vec2 st = (4. * fragCoord) / resolution.xy - 2.;\n    st.x *= resolution.x / resolution.y;\n    st = rotate(time / 8.) * st;\n\t\n    vec3 col;\n    vec2 o = vec2(cos(time / 4.1), sin(time / 2.));\n    \n    float t = -.001*time;\n    vec2 mp = 1.+4.*mouse.xy;\n    \n    for (int i = 0; i < 10; i++) {\n        for (float i = 0.; i < TWO_PI; i += TWO_PI / 16.) {\n            t += .6 * flower(vec2(st + polar(1., i)), 6.+mp.x, (4.4+mp.y) * \n                             sinp(time / 2.), time / 4.);\n        }\n\t\tcol[i] = sin(5. * t + length(st) * 8. * sinp(t));\n\t}\n\t\n\tfragColor = vec4(mix(col, vec3(1., .7, 0.), col.r), 1.0);\n    \n}\n\nvoid main( void ) \n{\n\tmainImage( gl_FragColor, gl_FragCoord.xy );\n}\n\n\n", "user": "17c21c1", "parent": "/e#47412.0", "id": 47429}