{"code": "\n#ifdef GL_ES\nprecision lowp float;\n#endif\n\n\nuniform float time;\nuniform vec2 resolution;\n\n\nconst float count = 7.0;\n\n\nfloat Hash( vec2 p, in float s)\n{\n    vec3 p2 = vec3(p.xy,27.0 * abs(sin(s)));\n    return fract(sin(dot(p2,vec3(27.1,61.7, 12.4)))*273758.5453123);\n}\n\n\nfloat noise(in vec2 p, in float s)\n{\n    vec2 i = floor(p);\n    vec2 f = fract(p);\n    f *= f * (3.0-2.0*f);\n\n\n    return mix(mix(Hash(i + vec2(0.,0.), s), Hash(i + vec2(1.,0.), s),f.x),\n               mix(Hash(i + vec2(0.,1.), s), Hash(i + vec2(1.,1.), s),f.x),\n               f.y) * s;\n}\n\n\nfloat fbm(vec2 p)\n{\n     float v = 0.0;\n     v += noise(p*1., 0.35);\n     v += noise(p*2., 0.25);\n     v += noise(p*4., 0.125);\n     v += noise(p*8., 0.0625);\n     return v;\n}\n\n\nvoid main( void ) \n{\n\n\nvec2 uv = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;\nuv.x *= resolution.x/resolution.y;\n\n\nvec3 finalColor = vec3( 0.0 );\nfor( float i=1.; i < count; ++i )\n{\nfloat t = abs(1.0 / ((uv.x + fbm( uv + time/i)) * (i*50.0)));\nfinalColor +=  t * vec3( i * 0.075 +0.1, 0.5, 2.0 );\n}\n\ngl_FragColor = vec4( finalColor, 1.0 );\n\n\n}", "user": "bf167cc", "parent": null, "id": 47416}