{"code": "//Could do with some severe performance improvements. It's a real duty on the fan atm :)\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nmat2 m = mat2( 0.90,  0.110, -0.70,  1.00 );\nfloat numfreq = 2.0;\n\nfloat hash( float n )\n{\n    return fract(sin(n)*758.5453);\n}\n\nfloat noise( in vec3 x )\n{\n    vec3 p = floor(x);\n    vec3 f = fract(x);\n    //f = f*f*(3.0-2.0*f);\n    float n = p.x + p.y*57.0 + p.z*800.0;\n    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),\n                    mix(mix( hash(n+800.0), hash(n+801.0),f.x), mix( hash(n+857.0), hash(n+858.0),f.x),f.y),f.z);\n    return res;\n}\n\nfloat fbm( vec3 p )\n{\n    float f = 0.0;\n    f += 0.50000*noise( p ); p = p*numfreq+0.02;\n    f += 0.25000*noise( p ); p = p*numfreq+0.03;\n    f += 0.12500*noise( p ); p = p*numfreq+0.01;\n    f += 0.06250*noise( p ); p = p*numfreq+0.04;\n    f += 0.03125*noise( p );\n    return f/0.984375;\n}\n\nfloat cloud(vec3 p)\n{\n\tp+=fbm(vec3(p.x,p.y,0.0)*0.5)*2.9;\n\t\n\t\n\tfloat a =0.0;\n\ta+=fbm(p*3.0)*2.2-0.9;\n\tif (a<0.0) a=0.0;\n\t//a=a*a;\n\treturn a;\n}\n\nvec3 f2(vec3 c)\n{\n\tc+=hash(time+gl_FragCoord.x+gl_FragCoord.y*9.9)*0.01;\n\t\n\t\n\tc*=0.7-length(gl_FragCoord.xy / resolution.xy -0.5)*0.7;\n\tfloat w=length(c);\n\tc=mix(c*vec3(1.0,1.2,1.6),vec3(w,w,w)*vec3(1.4,1.2,1.0),w*1.1-0.2);\n\treturn c;\n}\n\n\nfloat rand(vec2 co){\n    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43768.5453);\n}\n\nvoid main( void ) {\n    \n\tvec2 position = ( gl_FragCoord.xy / resolution.xy ) ;\n\tposition.y+=0.2;\n    \n\tvec2 coord= vec2((position.x-0.5)/position.y,1.0/(position.y+0.2))*vec2(-0.5,0.5);\n\tcoord+=time*0.01;\n\t\n\t\n\tfloat q = cloud(vec3(coord*1.0,time*0.0222));\n\tfloat qx= cloud(vec3(coord+vec2(0.156,0.0),time*0.0222));\n\tfloat qy= cloud(vec3(coord+vec2(0.0,0.156),time*0.0222));\n\tq+=qx+qy; q*=0.33333;\n\tqx=q-qx;\n\tqy=q-qy;\n\t\n\tfloat s =(-qx*2.0-qy*0.3); if (s<-0.05) s=-0.05;\n\t\n    vec3 d=s*vec3(0.9,0.6,0.3);\n    //d=max(vec3(0.0),d);\n\t//d+=0.1;\n\td*=0.3;\n\td=mix(vec3(1.0,1.0,1.0)*0.1+d*1.0,vec3(1.0,1.0,1.0)*0.9,1.0-pow(q,0.03)*1.1);\n    d*=8.0;\n    //d+=cos(time*0.01-0.5);\n        \n    //Stars\n\tfloat scale = 8.0;\n\tvec2 position2 = ((((gl_FragCoord.xy / resolution ))) * scale);\n\tfloat gradient = 0.0;\n\tfloat fade = 0.0;\n\tfloat z = 0.0;\n \tvec2 centered_coord = position2*rand(position)+(s*0.1)/2.0;\n\tvec3 color;\n\tfor (float i=1.0; i<=30.0; i++)\n\t{\n\t\tvec2 star_pos = vec2(rand(vec2(i)) * 250.0, rand(vec2(i*i)) * 250.0);\n\t\tfloat z = mod(sin(i*i*i)*s + 200.0, 256.0);\n\t\tfloat fade = (256.0 - z) /256.0;\n\t\tvec2 blob_coord = star_pos / z;\n\t\tgradient += ((fade / 384.0) / pow(length(centered_coord - blob_coord), 1.5)) * (fade);\n\t}\n\t\n    vec3 col =mix(vec3(sin(time*0.1-3.6)-2.0/(position.y*2.5+0.2),sin(time*0.1+0.5)/(position.y*9.5),0.2)*cos(time*0.1+sin(time*0.1-1.0))+gradient*cos(time*0.1),d,clamp(0.0,q*2.9,1.0));\n    \n    //vec3 col =mix(vec3(0.1,0.5,0.8)/(position.y*0.5+0.7)*gradient*0.1,d,q);\n    color = vec3(gradient, gradient, gradient / 1.0);\n\tcol += (color*0.6);\n    \n\tgl_FragColor = vec4( f2(col), 1.0 );\n}", "user": "b733647", "parent": null, "id": "18338.0"}