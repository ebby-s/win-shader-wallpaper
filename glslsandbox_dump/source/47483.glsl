{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n\nvoid main( void ) {\n        float dist= 2.;\n\tvec2 p = gl_FragCoord.xy / resolution.xy * 2. - 1.;\n\tp.x *= resolution.x/resolution.y;\n\tp*=2.;\n\tfloat a = atan(p.y,p.x);\n\tfloat l = length(p);\n        float c = sin((l+cos(a*1.-sin(a*3.)-time*2.2)+a*2.-time*1.));\n\t\n\tif((l*dist)<3.14/2.) c*=sin(l*dist);\n\tgl_FragColor = vec4( c,c*c,-c,1.0 );\n}", "user": "97e4020", "parent": "/e#39353.0", "id": 47483}