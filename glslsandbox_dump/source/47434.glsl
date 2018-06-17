{"code": "// Author @patriciogv ( patriciogonzalezvivo.com ) - 2015\n\n#ifdef GL_ES\nprecision highp float;\n#endif\n\n#define PI 3.14159265359\n\nuniform vec2 u_resolution;\nuniform float u_time;\n\nmat2 rotate2d(float _angle){\n    return mat2(cos(_angle),-sin(_angle),\n                sin(_angle),cos(_angle));\n}\n\nfloat box(in vec2 _st, in vec2 _size){\n    _size = vec2(0.5) - _size*0.5;\n    vec2 uv = smoothstep(_size,\n                        _size+vec2(0.001),\n                        _st);\n    uv *= smoothstep(_size,\n                    _size+vec2(0.001),\n                    vec2(1.0)-_st);\n    return uv.x*uv.y;\n}\n\nfloat cross(in vec2 _st, float _size){\n    return  box(_st, vec2(_size,_size/4.)) +\n            box(_st, vec2(_size/4.,_size));\n}\n\nvoid main(){\n    vec2 st = gl_FragCoord.xy/u_resolution.xy;\n    vec3 color = vec3(0.0);\n\n    // move space from the center to the vec2(0.0)\n    st -= vec2(0.5);\n    // rotate the space\n    st = rotate2d( sin(u_time)*PI ) * st;\n    // move it back to the original place\n    st += vec2(0.5);\n\n    // Show the coordinates of the space on the background\n    // color = vec3(st.x,st.y,0.0);\n\n    // Add the shape on the foreground\n    color += vec3(cross(st,0.4));\n\n    gl_FragColor = vec4(color,1.0);\n}\n", "user": "66fcc5d", "parent": null, "id": 47434}