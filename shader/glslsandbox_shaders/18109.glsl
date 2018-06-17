{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n// rakesh@picovico.com : www.picovico.com\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nconst float fRadius = 0.25;\n\nvoid main(void)\n{\n    vec2 uv = -1.0 + 2.0*gl_FragCoord.xy / resolution.xy;\n    uv.x *=  resolution.x / resolution.y;\n    \n    vec3 color = vec3(0.0);\n\n        // bubbles\n    for( int i=0; i<64; i++ )\n    {\n            // bubble seeds\n        float pha = tan(float(i)*6.+1.0)*0.5 + 0.5;\n        float siz = pow( cos(float(i)*2.4+5.0)*0.5 + 0.5, 4.0 );\n        float pox = cos(float(i)*3.55+4.1) * resolution.x / resolution.y;\n        \n            // buble size, position and color\n        float rad = fRadius + sin(float(i))*0.12+0.08;\n        vec2  pos = vec2( pox+sin(time/30.+pha+siz), -1.0-rad + (2.0+2.0*rad)\n                         *mod(pha+0.1*(time/5.)*(0.2+0.8*siz),1.0)) * vec2(1.0, 1.0);\n        float dis = length( uv - pos );\n        vec3  col = mix( vec3(0.1, 0.2, 0.8), vec3(0.2,0.8,0.6), 0.5+0.5*sin(float(i)*sin(time*pox*0.03)+1.9));\n        \n            // render\n        color += col.xyz *(1.- smoothstep( rad*(0.65+0.20*sin(pox*time)), rad, dis )) * (1.0 - cos(pox*time));\n    }\n\n    gl_FragColor = vec4(color,1.0);\n}\n\n\n", "user": "42a7de6", "parent": "/e#18102.0", "id": "18109.0"}