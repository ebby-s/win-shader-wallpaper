{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n\n// i'm searching for a nice way to animate that texture instead of just panning it from upper right to lower left\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.\n// Created by S.Guillitte \n\n\nfloat hash( in vec2 p ) \n{\n    return fract(sin(p.x*15.32+p.y*35.78) * 43758.23);\n}\n\nvec2 hash2(vec2 p)\n{\n\treturn vec2(hash(p*.754),hash(1.5743*p.yx+4.5891))-.5;\n}\n\n\nvec2 add = vec2(1.0, 0.0);\n\nvec2 noise2(vec2 x)\n{\n    vec2 p = floor(x);\n    vec2 f = fract(x);\n    f = f*f*(3.0-2.0*f);\n    \n    return mix(mix( hash2(p),          hash2(p + add.xy),f.x ),\n                    mix( hash2(p + add.yx), hash2(p + add.xx),f.x),f.y);\n    \n}\n\n\n\nvec2 fbm2(vec2 x)\n{\n    vec2 r = x;\n    float a = 1.;\n    \n    for (int i = 0; i < 4; i++)\n    {\n        r += noise2(r*a)/a;\n\tr += noise2(r*sin(time * 0.005));\n\n    }     \n    return (r-x)*sqrt(a);\n}\n\n\n\n\nvoid main( void ) \n{\n    vec2 uv = 2.*gl_FragCoord.xy / resolution.yy;\n    uv*=20.;\n    vec2 p = fbm2(uv+1.*time)+2.;\n    float c = length(p);\n    vec3 col;\n    col=vec3(0.6,0.7,0.8+.05*p.y)*c/5.;\n\tgl_FragColor = vec4(col,1.0);\n}", "user": "997d9b8", "parent": null, "id": "26458.0"}