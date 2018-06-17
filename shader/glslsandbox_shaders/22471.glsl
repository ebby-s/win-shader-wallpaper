{"code": "// too many damn distance fields on glsl sandbox,\n// how about some volume rendering?!\n// @simesgreen\n\n#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform vec2 resolution;\nuniform float time;\nuniform vec2 mouse;\nuniform float zoom;\n\nuniform vec2 surfaceSize;\nuniform vec2 surfacePosition;\n\nconst int _VolumeSteps = 128;\nconst float _StepSize = 0.05; \nconst float _Density = 0.2;\n\nconst float _SphereRadius = 2.0;\nconst float _NoiseFreq = 2.0;\nconst float _NoiseAmp = 2.0;\nconst vec3 _NoiseAnim = vec3(0, 0, 0);\n\n// iq's nice integer-less noise function\n\n// matrix to rotate the noise octaves\nmat3 m = mat3( 0.00,  0.80,  0.60,\n              -0.80,  0.36, -0.48,\n              -0.60, -0.48,  0.64 );\n\nfloat hash( float n )\n{\n    return fract(sin(n)*43758.5453);\n}\n\n\nfloat noise( in vec3 x )\n{\n    vec3 p = floor(x);\n    vec3 f = fract(x);\n\n    f = f*f*(3.0-2.0*f);\n\n    float n = p.x + p.y*57.0 + 113.0*p.z;\n\n    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),\n                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),\n                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),\n                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);\n    return res;\n}\n\nfloat fbm( vec3 p )\n{\n    float f;\n    f = 0.5000*noise( p ); p = m*p*2.02;\n    f += 0.2500*noise( p ); p = m*p*2.03;\n    f += 0.1250*noise( p ); p = m*p*2.01;\n    f += 0.0625*noise( p );\n    //p = m*p*2.02; f += 0.03125*abs(noise( p ));\t\n    return f;\n}\n\n// returns signed distance to surface\nfloat distanceFunc(vec3 p)\n{\t\n\tfloat d = length(p) - _SphereRadius;\t// distance to sphere\n\t\n\t// offset distance with pyroclastic noise\n\t//p = normalize(p) * _SphereRadius;\t// project noise point to sphere surface\n\td += fbm(p*_NoiseFreq + _NoiseAnim*time) * _NoiseAmp;\n\treturn d;\n}\n\n// color gradient \n// this should be in a 1D texture really\nvec4 gradient(float x)\n{\n\treturn vec4(fract(x*0.9));\n\t// no constant array initializers allowed in GLES SL!\n\tconst vec4 c0 = vec4(2, 2, 1, 1);\t// yellow\n\tconst vec4 c1 = vec4(1, 0, 0, 1);\t// red\n\tconst vec4 c2 = vec4(0, 0, 0, 0); \t// black\n\tconst vec4 c3 = vec4(0, 0.5, 1, 0.5); \t// blue\n\tconst vec4 c4 = vec4(0, 0, 0, 0); \t// black\n\t\n\tx = clamp(x, 0.0, 0.999);\n\tfloat t = fract(x*4.0);\n\tvec4 c;\n\tif (x < 0.25) {\n\t\tc =  mix(c0, c1, t);\n\t} else if (x < 0.5) {\n\t\tc = mix(c1, c2, t);\n\t} else if (x < 0.75) {\n\t\tc = mix(c2, c3, t);\n\t} else {\n\t\tc = mix(c3, c4, t);\t\t\n\t}\n\t//return vec4(x);\n\t//return vec4(t);\n\treturn c;\n}\n\n// shade a point based on distance\nvec4 shade(float d)\n{\t\n\t// lookup in color gradient\n\tvec4 c = gradient(d);\n\treturn c;\n\t//return mix(vec4(1, 1, 1, 1), vec4(0, 0, 0, 0), smoothstep(1.0, 1.1, d));\n}\n\n// procedural volume\n// maps position to color\nvec4 volumeFunc(vec3 p)\n{\n\tfloat d = distanceFunc(p);\n\treturn shade(d);\n}\n\n// ray march volume from front to back\n// returns color\nvec4 rayMarch(vec3 rayOrigin, vec3 rayStep, out vec3 pos)\n{\n\tvec4 sum = vec4(0, 0, 0, 0);\n\tpos = rayOrigin;\n\tfor(int i=0; i<_VolumeSteps; i++) {\n\t\tvec4 col = volumeFunc(pos);\n\t\tcol.a *= _Density;\n\t\t//col.a = min(col.a, 1.0);\n\t\t\n\t\t// pre-multiply alpha\n\t\tcol.rgb *= col.a;\n\t\tsum = sum + col*(1.0 - sum.a);\t\n#if 0\n\t\t// exit early if opaque\n        \tif (sum.a > _OpacityThreshold)\n            \t\tbreak;\n#endif\t\t\n\t\tpos += rayStep;\n\t}\n\treturn sum;\n}\n\nvoid main(void)\n{\n    vec2 q = gl_FragCoord.xy / resolution.xy;\n    vec2 p = -1.0 + 2.0 * q;\n    p.x *= resolution.x/resolution.y;\n\tp *= 1.8;\n\t\n    float rotx = mouse.y*4.0;\n    float roty = - mouse.x*4.0;\n\n    float zoom = 5.0*surfaceSize.y;\n\n    // camera\n    vec3 ro = zoom*normalize(vec3(cos(roty), cos(rotx), sin(roty)));\n    vec3 ww = normalize(vec3(0.0,0.0,0.0) - ro);\n    vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));\n    vec3 vv = normalize(cross(ww,uu));\n    vec3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww );\n\n    ro += rd*2.0;\n\t\n    // volume render\n    vec3 hitPos;\n    vec4 col = rayMarch(ro, rd*_StepSize, hitPos);\n    //vec4 col = gradient(p.x);\n\t    \n    gl_FragColor = col;\n}", "user": "789b9fa", "parent": "/e#2902.4", "id": "22471.0"}