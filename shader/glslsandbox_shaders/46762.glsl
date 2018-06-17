{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\n\nvoid main(void) {\n    float t = mod(time, 5.);\n    vec3 col = vec3(0.);\n\n    if (t >= 1. && t < 2.) {\n        col.r = 1.;\n    }\n    else if (t >= 2. && t < 3.) {\n        col.g = 1.;\n    }\n    else if (t >= 3. && t < 4.) {\n        col.b = 1.;\n    }\n    else if (t >= 4.) {\n        col = vec3(1.);\n    }\n\n    gl_FragColor = vec4(col, 1.);\n}", "user": "8b9d178", "parent": null, "id": "46762.0"}