{"code": "precision mediump float;uniform vec2 resolution;uniform vec2 mouse;//Robert Sch\u00fctze (trirop) 07.12.2015\nvoid main(){vec3 p = vec3((gl_FragCoord.xy)/(resolution.y),mouse.x);\n  for (int i = 0; i < 100; i++){\n    p.xzy = vec3(1.3,0.999,0.7)*(abs((abs(p)/dot(p,p)-vec3(1.0,1.0,mouse.y*0.5))));}\n  gl_FragColor.rgb = p;gl_FragColor.a = 1.0;}", "user": "cd89fc6", "parent": null, "id": "29611.0"}