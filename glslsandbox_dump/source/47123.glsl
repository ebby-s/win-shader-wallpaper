{"code": "// added mouse handling..\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n\t\n\tvec2 pos = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5,0.5);\t\n        float horizon = -0.3*cos(mouse.y*10.0/3.0); \n        float fov = 0.6; \n\tfloat scaling = 0.61;\n\t\n\tvec3 p = vec3(pos.x, fov, pos.y - horizon);\n\tfloat a = -mouse.x*0.1*time;\n\tvec3 q = vec3(p.x*cos(a)+p.y*sin(a), p.x*sin(a)-p.y*cos(a),p.z);\n\tvec2 s = vec2(q.x/q.z, q.y/q.z) * scaling;\n\n\t//checkboard texture\n\tfloat color = sign((mod(s.x, 0.1) - 0.05) * (mod(s.y, 0.1) - 0.05));\t\n\t//fading\n\tcolor *= p.z*p.z*(8.0+2.0*sin(time*3.));\n\t\n\tgl_FragColor = vec4( color*vec3(1.0, s.x, s.y), 1.0 );\n}", "user": "84a6813", "parent": "/e#47107.0", "id": 47123}