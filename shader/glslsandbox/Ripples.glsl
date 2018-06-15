{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nfloat hash(float x)\n{\n\treturn fract(sin(x) * 43758.5453);\n}\n\nfloat noise(vec3 x)\n{\n\tvec3 p = floor(x);\n\tvec3 f = fract(x);\n\tf = f*f*(3.0-2.0*f);\n\tfloat n = p.x + p.y * 57.0 + p.z*113.0;\n\t\n\tfloat a = hash(n);\n\treturn a;\n}\n\nfloat manhattan(vec3 v)\n{\n\tv = abs(v);\n\treturn v.x + v.y + v.z;\n}\n\nfloat quad(vec3 v)\n{\n\treturn pow(pow(v.x,4.0) + pow(v.y,4.0) + pow(v.z,4.0), 0.25);\n}\n\nfloat cheby(vec3 v)\n{\n\tv = abs(v);\n\treturn v.x > v.y\n\t? (v.x > v.z ? v.x : v.z)\n\t: (v.y > v.z ? v.y : v.z);\n}\n\nfloat vor(vec3 v)\n{\n\tvec3 start = floor(v);\n\t\n\tfloat dist = 9999999.0;\n\tvec3 cand;\n\t\n\tfor(int z = -2; z <= 2; z += 1)\n\t{\n\t\tfor(int y = -2; y <= 2; y += 1)\n\t\t{\n\t\t\tfor(int x = -2; x <= 2; x += 1)\n\t\t\t{\n\t\t\t\tvec3 t = start + vec3(x, y, z);\n\t\t\t\tvec3 p = t + noise(t);\n\n\t\t\t\tfloat d = length(p - v);\n\n\t\t\t\tif(d < dist)\n\t\t\t\t{\n\t\t\t\t\tdist = d;\n\t\t\t\t\tcand = p;\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t}\n\t\n\tvec3 delta = cand - v;\n\t\n\treturn length(delta);\n\t//return noise(cand); //length(delta);\n}\n\n\nvec3 turb(vec3 v)\n{\n\tvec2 pos = ( gl_FragCoord.xy / resolution.xy );\n\t\n\tfloat n = vor( v );\n\t\n\tv.x += n * 20.0;\n\tv.y += n * 20.0;\n\t\n\treturn v;\n}\n\nfloat doVoronoi()\n{\n\tvec3 freq = vec3(0.01, 0.01, 0.2);\t\n\n\tfloat n = 0.0;\n\tfloat amplitude = 1.0;\n\tfloat pers = 0.25;\n\t\n\tvec3 tc = vec3(gl_FragCoord.xy, time);\n\t\n\tfloat maxAmp = 0.0;\n\t\n\t//for(int i = 0; i < 6; ++i)\n\t//{\n\t\tn += vor( turb( tc * freq ) ) * amplitude;\n\t\t\n\t\tfreq *= 2.0;\n\t\t\n\t\tmaxAmp += amplitude;\n\t\t\n\t\tamplitude *= pers;\t\n\t//}\n\t//n /= maxAmp;\n\t\n\t\n\tn = -n + 1.0;\n\treturn n;\n}\nvoid main( void )\n{\n\tfloat n = 0.0;\n\t\n\tn += doVoronoi();\n\n\tvec4 col = vec4(0.0);\n\t\n\tvec4 red = vec4(1.0, 0.0, 0.0, 1.0);\n\tvec4 yel = vec4(1.0, 1.0, 0.0, 1.0);\n\tvec4 grn = vec4(0.0, 1.0, 0.0, 1.0);\n\tvec4 tur = vec4(0.0, 1.0, 1.0, 1.0);\n\tvec4 blu = vec4(0.0, 0.0, 1.0, 1.0);\t\n\tvec4 pur = vec4(1.0, 0.0, 1.0, 1.0);\n\t// then red again\n\n\tfloat c = 6.0;\n\tfloat rng = 1.0 / c; // 0.1666666666666667\n\n\tif(\t\tn < rng*1.0) col = mix(red, yel, (n-rng*0.0) * c);\n\telse if(n < rng*2.0) col = mix(yel, grn, (n-rng*1.0) * c);\n\telse if(n < rng*3.0) col = mix(grn, tur, (n-rng*2.0) * c);\n\telse if(n < rng*4.0) col = mix(tur, blu, (n-rng*3.0) * c);\n\telse if(n < rng*5.0) col = mix(blu, pur, (n-rng*4.0) * c);\n\telse if(n < rng*6.0) col = mix(pur, red, (n-rng*5.0) * c);\n\t\t\n\tgl_FragColor = vec4(n);\n}\n", "user": "15bec49", "parent": "/e#9451.2", "id": "9484.0"}