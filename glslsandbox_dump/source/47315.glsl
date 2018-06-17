{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvec3 pal( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )\n{\n    return a + b*cos( 6.28318*(c*t+d) );\n}\n\nvoid main( void ) {\n\n\tvec2 position = ( gl_FragCoord.xy * 2.0 -  resolution) / min(resolution.x, resolution.y);\n\tposition *= 5.0;\n\tvec3 destColor = vec3(1.0, 0.0, 1.5 );\n\tfloat f = 0.05;\n\tfloat s,c;\n\tfor(float i = 0.5; i < 10.0; i++){\n\t\t\n\t\ts = sin(time - i - c);\n\t\tc = cos(time + i + s);\n\t\tf += 0.02 / abs(length(3.0* position *f - vec2(c, s)) -0.4);\n\t}\n        if(f>1.0) f= 1.0;\n\tf/=1.;\n\tgl_FragColor = vec4(pal( f, vec3(0.5,0.5,0.5),vec3(0.5,0.5,0.5),vec3(1.0,1.0,0.5),vec3(0.8,0.90,0.30)) , 1.0);\n}", "user": "b4618c2", "parent": "/e#41935.0", "id": 47315}