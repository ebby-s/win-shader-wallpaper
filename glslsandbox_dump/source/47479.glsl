{"code": "/*\n * Original shader from: https://www.shadertoy.com/view/4dyfWW\n */\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n// glslsandbox uniforms\nuniform float time;\nuniform vec2 resolution;\n\n// shadertoy globals\nfloat iTime;\nvec3  iResolution;\n\n// --------[ Original ShaderToy begins here ]---------- //\nfloat random (in vec2 st) {\n\treturn fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);\n}\nfloat noise (in vec2 st)\n{\n\tvec2 i = floor(st);\n\tvec2 f = fract(st);\n\tfloat a = random(i);\n\tfloat b = random(i + vec2(1.0, 0.0));\n\tfloat c = random(i + vec2(0.0, 1.0));\n\tfloat d = random(i + vec2(1.0, 1.0));\n\tvec2 u = f*f*(3.0-2.0*f);\n\treturn mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;\n}\n/*\nvec2 rotate(vec2 v, float a)\n{\n\tvec2 r = vec2(cos(a), sin(a));\n\treturn vec2(r.x * v.x - r.y * v.y, r.y * v.x + r.x * v.y);\n}\n*/\nmat2 rot(float a)\n{\n    vec2 r = vec2(cos(a), sin(a));\n    return mat2(r.x, r.y, -r.y, r.x);\n}\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n    vec2 pos = (2.*fragCoord - iResolution.xy ) / iResolution.y;\n\t//pos = rotate(pos, -1.0 * length(pos) + 2.0 / length(pos) + 2.0 * iTime);\n\tpos *= rot(length(pos) - 2.0 / length(pos) - 2.0 * iTime);\n    vec3 col = 0.2 * vec3(0.2 * (1.0 + 0.5 * sin(4.0 * pos.x)), 0.4, 0.8 * (1.0 + 0.25 * sin(iTime))) * (dot(pos, pos) + 0.01 / dot(pos, pos));\n    float light = 0.;\n    for(int i = 0; i < 5; i++)\n        light += pow(0.5, float(i)) * noise(pow(2.0, float(i)) * pos + 0.1 * iTime);\n    col += 0.4 * vec3(0.2, 0.5, 1.0) * light;\n    /*\n    for(int i = 0; i < 5; i++)\n        col += 0.4 * vec3(0.2, 0.5, 1.0) * pow(0.5, float(i))  * noise(2.0 * float(i) * pos + 0.1 * iTime);\n    */\n    fragColor = vec4(col,1.0);\n}\n// --------[ Original ShaderToy ends here ]---------- //\n\nvoid main(void)\n{\n    iTime = time;\n    iResolution = vec3(resolution, 0.0);\n\n    mainImage(gl_FragColor, gl_FragCoord.xy);\n}", "user": "9953559", "parent": null, "id": 47479}