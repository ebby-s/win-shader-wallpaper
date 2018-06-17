{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nfloat length_v2( vec2 vec )\n{\n\treturn (+sqrt ( vec.x * vec.x + vec.y * vec.y ));\n}\n\nfloat sum_v4( vec4 v )\n{\n\treturn v.x + v.y + v.z + v.w;\n}\n\nvoid main( void ) {\n\n\tvec2 center = ( mouse.xy * resolution.xy );\n\tvec2 diff = gl_FragCoord.xy - center;\n\tfloat light_radius = 250.0;\n\tfloat dist = length_v2( diff );\n\tfloat intensity = 0.5 - dist / light_radius;\n\tvec4 color = vec4 ( intensity, intensity, intensity, 1.0 );\n\t\n\tvec4 background_color = vec4 ( fract( (cos(gl_FragCoord.x) / sin( gl_FragCoord.y))+time*.123454321), 0.0, 0.0, 1.0 );\n\t\n\tif ( sum_v4( background_color ) > 1.6 ){\n\t\tgl_FragColor = mix (color, background_color, 0.4 );\n\t}else {\n\t\tgl_FragColor = vec4( 0.0, 0.0, 0.0, 1.0 );\n\t}\n\t\n\n}", "user": "1ffb629", "parent": "/e#47206.2", "id": 47371}