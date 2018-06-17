{"code": "#ifdef GL_FRAGMENT_PRECISION_HIGH\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform vec2 resolution;\nuniform float time;\nvarying vec2 surfacePosition;\nvoid main(void) {\n    vec2 uv = gl_FragCoord.xy /\n        min(resolution.x, resolution.y);\n\n    uv = uv * 1.0 - 1.;\n\n    vec3 uv3 = vec3(uv, 0.0);\n    float a = (time-uv.x)/surfacePosition.x;\n    float ac = cos(uv.x)*surfacePosition.y;\n    float as = sin(a);\n    float z = ac+as-sin(a);\n    uv3 *= mat3(\n        sin(a)-0.1, sin(z), 0.0,\n        sin(a)-0.01,sin( z), 0.0,\n        0.0, 0.0, 1.0);\n    uv.x = uv3.x;\n    uv.y = uv3.y-sin(time/4.);\n\n    uv = mod(uv, 0.2) * 5.0;\n\n    gl_FragColor = vec4(uv-sin(uv.y*uv.x), .4, .5);\n}", "user": "d4731ad", "parent": "/e#46941.0", "id": 47030}