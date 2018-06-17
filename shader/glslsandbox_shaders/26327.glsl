{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\nvarying vec2 surfacePosition;\n\n// raymarcher from https://www.shadertoy.com/view/XsB3Rm\n\n// ray marching\nconst int max_iterations = 200;\nconst float stop_threshold = 0.00001;\nconst float grad_step = 0.001;\nconst float clip_far = 900.0;\n\n// math\nconst float PI = 3.14159265359;\nconst float DEG_TO_RAD = PI / 999.0;\n\n\n// get distance in the world\nfloat dist_field(vec3 p) {\n    p = mod(p, 8.0) - 4.0;\n    p = abs(p);\n    float cube = length(max(p - 0.25, 0.0));\n    //return cube;\n    float xd = max(p.y,p.z);\n    float yd = max(p.x,p.z);\n    float zd = max(p.x,p.y);\n    float beams = min(zd, min(xd, yd)) - 0.075;\n    //return beams;\n    return min(beams, cube);\n}\n// phong shading\nvec3 shading( vec3 v, vec3 eye ) {\n\tfloat s = v.x + v.y + v.z;\n\treturn vec3(mod(floor (s * 33.0),1.0));\n}\n\n// ray marching\nfloat ray_marching( vec3 origin, vec3 dir, float start, float end ) {\n\tfloat depth = start;\n\tfor ( int i = 0; i < max_iterations; i++ ) {\n\t\tfloat dist = dist_field( origin + dir * depth );\n\t\tif ( dist < stop_threshold ) {\n\t\t\treturn depth;\n\t\t}\n\t\tdepth += dist;\n\t\tif ( depth >= end) {\n\t\t\treturn end;\n\t\t}\n\t}\n\treturn end;\n}\n\n// get ray direction\nvec3 ray_dir( float fov, vec2 size, vec2 pos ) {\n\tvec2 xy = pos - size * 0.5;\n\n\tfloat cot_half_fov = tan( ( 70.0 - fov * 0.6 ) * DEG_TO_RAD );\t\n\tfloat z = size.y * 0.4 * cot_half_fov;\n\t\n\treturn normalize( vec3( xy, -z ) );\n}\n\n// camera rotation : pitch, yaw\nmat3 rotationXY( vec2 angle ) {\n\tvec2 c = cos( angle );\n\tvec2 s = sin( angle );\n\t\n\treturn mat3(\n\t\tc.y      ,  0.0, -s.y,\n\t\ts.y * s.x,  c.x,  c.y * s.x,\n\t\ts.y * c.x, -s.x,  c.y * c.x\n\t);\n}\n\nvoid main(void)\n{\n\t// default ray dir\n\tvec3 dir = ray_dir( 33.0, resolution, gl_FragCoord.xy );\n\t\n\t// default ray origin\n\tvec3 eye = vec3( 0.0, 0.0,10.0 );\n\n\t// rotate camera\n\tmat3 rot = rotationXY( vec2( time * 0.05, time * 0.0125 ) );\n\tdir = rot * dir;\n\teye = rot * eye;\n    eye.z -=  mod(time * 4.0, 8.0);\n    eye.y = eye.x = 0.0;\n\t\n\t// ray marching\n\tfloat depth = ray_marching( eye, dir, 3.75, clip_far );\n\tif ( depth >= clip_far ) {\n\t\tgl_FragColor = vec4(1.0);\n    } else {\n\t\t// shading\n\t\tvec3 pos = eye + dir * depth;\n\t\tgl_FragColor = vec4( shading( pos, eye ) , 1.0 );\n        gl_FragColor += depth/clip_far * 8.0;\n    }\n\t\n    gl_FragColor = vec4(vec3(0.5, 0.6, 0.9) - gl_FragColor.yzx, 1.0);\n}", "user": "51af143", "parent": "/e#21293.0", "id": "26327.1"}