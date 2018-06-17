{"code": "// Mandelbrot/Julia set \n// idea stolen from https://www.shadertoy.com/view/Xs3XWH\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform vec2 mouse;\nuniform vec2 resolution;\nuniform float time;\n\nfloat aspectInv = resolution.y/resolution.x;\nconst bool drawLine = true;\nconst bool drawPoints = true;\nconst float thickness = 1.0/200.0;\nconst int iterations = 100;\nconst float bailout = 2.0;\n\nvec2 uvmap(vec2 pixels) {\n    vec2 uv = (pixels/resolution)*2.0 - 1.0;\n    uv.y *= aspectInv;\n    return vec2(uv.y,uv.x);\n}\n\nfloat map(float x, float oldMin, float oldMax, float newMin, float newMax) {\n    return newMin + (x - oldMin)/(oldMax - oldMin)*(newMax - newMin);\n}\n\nvec2 map(vec2 p, vec2 oldMin, vec2 oldMax, vec2 newMin, vec2 newMax) {\n    p.x = map(p.x, oldMin.x, oldMax.x, newMin.x, newMax.x);\n    p.y = map(p.y, oldMin.y, oldMax.y, newMin.y, newMax.y);\n    return p;\n}\n\nfloat line(vec2 uv, vec2 start, vec2 end) {\n    vec2 pa = uv - start;\n    vec2 ba = end - start;\n    float h = clamp (dot (pa, ba) / dot (ba, ba), 0.0, 1.0);\n    float d = length (pa - ba * h);\n    \n    return 1.0-clamp(d/thickness, 0.0, 1.0);\n}\n\nvec2 function(vec2 z, vec2 c) {\n    return vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;\n}\n\nvec4 plot(vec2 z0, vec2 c, bool julia) {\n    vec3 set = vec3(0);\n    float hue = 0.0;\n    vec2 z = z0;\n\t\n    for(int i = 0; i < iterations; i++)\n    {\n\tfloat absZ = length(z);\n\tif(absZ > bailout)\n\t{\n\n\t    hue /= float(iterations);\n\t    set += vec3(1.);\n\t    break;\n\t}\n\tz = function(z, c);\n        if(drawPoints) set += line(z0, z, z)/float(iterations);\n    }\n\t\n    return vec4(set, 1.0);\n}\n\nvec4 plot(vec2 uv, vec2 c) {\n    vec3 path = vec3(0);\n    vec2 z = vec2(0);\n\tvec4 color = vec4(1.);\n    for(int i = 0; i < iterations; i++)\n    {\n\t    if(length(z) > bailout) { color = vec4(vec3(0.),1.); break;}\n\tvec2 newZ = function(z, c);\n\tz = newZ;\n    }\n\n    return vec4(color);\n}\n\t\nvoid main( void ) {\n\t\n    vec2 uv = uvmap(gl_FragCoord.xy)*2.-vec2(0.5,0.);\n    vec2 ms = uvmap(mouse*resolution)-vec2(0.5,0.);\n\n   // ms = map(ms, vec2(-1, -aspectInv), vec2(0, aspectInv), vec2(-2, -2), vec2(2, 2));\n\t\n   // if(uv.x < 0.0)\n    {\n\t            gl_FragColor = vec4(vec3(0.),1);\n        gl_FragColor -= plot(uv, uv, false);\n        gl_FragColor-= vec4(plot(uv, ms, false).x);\n    }\n\t\n    if(drawLine) gl_FragColor += plot(uv, ms);\n}", "user": "a2bee14", "parent": "/e#46524.0", "id": 47236}