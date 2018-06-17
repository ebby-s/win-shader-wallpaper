{"code": "/*\n * Original shader from: https://www.shadertoy.com/view/XdcGzH\n */\n\n#extension GL_OES_standard_derivatives : enable\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n// glslsandbox uniforms\nuniform float time;\nuniform vec2 resolution;\nuniform vec2 mouse;\n// shadertoy globals\nfloat iTime;\nvec3  iResolution;\nconst float e = 2.71828183;\n// Protect glslsandbox uniform names\n#define time        stemu_time\n#define resolution  stemu_resolution\n\n// --------[ Original ShaderToy begins here ]---------- //\n//Public domain\n#define PI 3.14159\n#define A2B PI/360.\n#define MaxIter 15\n#define ScaleF 3.5\n#define SquareLoop 1\n\nvec2 c_mul(vec2 c1, vec2 c2)\n{\n\tfloat a = c1.x;\n\tfloat b = c1.y;\n\tfloat c = c2.x;\n\tfloat d = c2.y;\n\treturn vec2(a*c - b*d, b*c + a*d);\n}\n\n\n\nfloat color(vec2 z, vec2 c) {\n\tfloat res = 1.0;\n\tfor (int i=0; i < MaxIter;i++) {\n\t\tfor (int o = 0; o < SquareLoop;o++)\n\t\t\tz = c_mul(z,z);\n\t\t\n\t\tz += c;\n\t\tif (length(z) > 4.0) {\n\t\t\tres = float(i)/float(MaxIter);\n\t\t\tbreak;\n\t\t}\n\t}\n\treturn (res);\n}\n\nfloat Box(vec2 z, vec2 c) {\n\tfloat res = color(z,c);\n\tbool flag = false;\n\tfor(float x= -1.; x <= 1.; x+=1.0) {\n\t\tfor(float y = -1.0;y <= 1.0;y+=1.0) {\n\t\t\tfloat tmp = color(z+vec2(x,y)*0.002,c);\n\t\t\tif (tmp != res) {\n\t\t\t\tflag = true;\n\t\t\t\tbreak;\n\t\t\t}\t\t\t\t\t\n\t\t}\n\t\tif (flag)\n\t\t\tbreak;\n\t}\n\tif (flag)\n\t\treturn(0.0);\n\telse\n\t\treturn(1.0);\n\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n\tvec2 c = (mouse.xy - vec2(0.5,0.5))*2. + vec2(cos(iTime*0.8),sin(iTime*0.568))*0.01;\n\t\n\tvec2 uv = ScaleF*(fragCoord.xy-0.5*iResolution.xy) / iResolution.x;\n    uv.y+=0.;\n\t\n\tfloat p = Box(uv,c);//color(uv,c);\n\tfragColor = vec4(p, p, p, 1.0);\n}\n\n\n#undef time\n#undef resolution\n\nvoid main(void)\n{\n  iTime = time;\n  iResolution = vec3(resolution, 0.0);\n\n  mainImage(gl_FragColor, gl_FragCoord.xy);\n}", "user": "2b62acb", "parent": "/e#45388.0", "id": 47445}