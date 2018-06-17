{"code": "\n//---------------------------------------------------------\n// Shader:   Terrain2013.glsl      by w23   5/2015\n// original: https://www.shadertoy.com/view/ldfGDN  \n// tags:     noise, terrain, raymarch, 3d, clouds \n//---------------------------------------------------------\n#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n//---------------------------------------------------------\n#define MAX_DISTANCE 25000.\n#define CLOUDS_HEIGHT_MAX 3500.\n#define CLOUDS_HEIGHT_MIN 1000.\n\nvarying vec2 p;\n\nfloat t;\nconst float c_pi = 3.1415926;\n\nstruct ray_t { vec3 origin, dir; };\n#define RT(r,l) (r.origin + r.dir * l)\n\nstruct material_t { vec3 diffuse; float specular; };\n\nstruct light_dir_t { vec3 color, dir; };\n\nmaterial_t cmat = material_t(vec3(.6, .75, .2), 500000.);\nlight_dir_t sun = light_dir_t(vec3(1., .9, .5), normalize(vec3(1.3, 1., -.2)));\n\n// Make a ray using normalized pixel position, eye position and focus point\nray_t lookAtDir(in vec3 uv_dir, in vec3 pos, in vec3 at) {\n\tvec3 f = normalize(at - pos);\n\tvec3 r = cross(f, vec3(0.,1.,0.));\n\tvec3 u = cross(r, f);\n\treturn ray_t(pos, normalize(uv_dir.x * r + uv_dir.y * u + uv_dir.z * f));\n}\n\nfloat hash(in float x) { return fract(sin(x*.0007)*29835.24389); }\nfloat hash(in vec2 x) { return hash(dot(x,vec2(23.17,17.23))); }\nfloat hash(in vec3 x) { return hash(dot(x,vec3(23.17,17.23,42.5))); }\nfloat noise_value(in vec2 p) {\n\tvec2 e=vec2(1.,0.), F = floor(p), f = fract(p), k = (3. - 2.*f) * f * f;\n\treturn mix(mix(hash(F),      hash(F+e.xy), k.x),\n\t\t\t   mix(hash(F+e.yx), hash(F+e.xx), k.x), k.y);\n}\nfloat noise_value(in vec3 p) {\n\tvec2 e = vec2(1.,0.);\n\tvec3 F = floor(p), f = fract(p), k = (3. - 2.*f) * f * f;\n\treturn mix(\n\t\t   mix(mix(hash(F),       hash(F+e.xyy), k.x),\n\t\t\t   mix(hash(F+e.yxy), hash(F+e.xxy), k.x), k.y),\n\t\t   mix(mix(hash(F+e.yyx), hash(F+e.xyx), k.x),\n\t\t\t   mix(hash(F+e.yxx), hash(F+e.xxx), k.x), k.y), k.z);\n}\n\nfloat terrain_height(in vec3 at) {\n\tfloat k = .5;\n\tvec2 p = at.xz * .0005;\n\tmat2 m = mat2(1.3,  1.5, 1.5, -1.3);\n\tfloat h = 0.;//noise_value(p) * k;\n\tfor (int i = 0; i < 8; ++i) { h += noise_value(p) * k; k *= .5; p = m * p; }\n\treturn 1200. * h * h * h * h;\n}\n\t\nfloat terrain_distance(in vec3 at) {\n\treturn min(1.+at.y,at.y - terrain_height(at));\n}\n\nfloat cloud_noise(in vec3 p) {\n    p.xz *= 0.3;\n    float k = .5, v = 0.;\n    v += noise_value(p) * k; k *= .45; p =  p * 2.01;\n    v += noise_value(p) * k; k *= .35; p =  p * 2.01;\n    v += noise_value(p) * k; k *= .25; p =  p * 2.01;\n    v += noise_value(p) * k; k *= .15; p =  p * 2.01;\n    return v;\n}\n\nvec4 accum = vec4(0.);\nfloat prevV = 0.;\nfloat dist = 0.;\nfloat solid = 0.;\n\nfloat world(in vec3 at, in vec3 dir) {\n\tif (at.y > CLOUDS_HEIGHT_MAX)\n\t\treturn (dir.y < 0.) ? (at.y - CLOUDS_HEIGHT_MAX + 10.) / -dir.y : 1000.;\n\tif (at.y > CLOUDS_HEIGHT_MIN) {\n\t\tvec3 cs = at*.001 - t *.3;\n\t\tfloat k = sin((at.y - CLOUDS_HEIGHT_MIN) / (CLOUDS_HEIGHT_MAX - CLOUDS_HEIGHT_MIN) * c_pi),\n\t\t\tv = cloud_noise(cs) * k,\n\t\t\tV = max(0., v * v - .13);\n\t\tif (V > .0) {\n\t\t\tfloat A = ((V + prevV) * .5 * dist) * .005;\n\t\t\t//vec3 cloudcolor = vec3(.125);// * V;// + sun.color * max(0.,(-cloud_noise(cs+sun.dir*.01)+v))*7.725;\n\t\t\tvec3 cloudcolor = vec3(1.) + sun.color * max(0.,(-cloud_noise(cs+sun.dir*100.)+v)) * 1.7;\n\t\t\taccum.rgb += cloudcolor * A * (1. - accum.a);\n\t\t\taccum.a += A;\n\t\t}\n\t\tprevV = V;\n\t\treturn 11. + 200. * (1. - V);\n\t}\n\tfloat H = terrain_distance(at);\n\treturn (dir.y <= 0.) ? H : min(H, (CLOUDS_HEIGHT_MIN + 10. - at.y) / dir.y);\n}\n\nvec3 normal(in vec3 at) {\n\tvec2 e = vec2(.1, .0);\n\treturn normalize(vec3(world(at+e.xyy, vec3(0.))-world(at, vec3(0.)),\n\t\t  world(at+e.yxy, vec3(0.))-world(at, vec3(0.)),\n\t\t  world(at+e.yyx, vec3(0.))-world(at, vec3(0.))));\n}\n\nfloat trace(in ray_t ray, in float maxPath) {\n\tfloat path = 0.;\n\tfor (int i = 0; i < 128; ++i) {\n\t\tdist = world(RT(ray, path), ray.dir);\n\t\tif (dist < .001*path) { solid = 1.; break; }\n\t\tif (accum.a >= 1.) break;\n\t\tpath += dist;\n\t\tif (path > maxPath) break;\n\t}\n\treturn path;\n}\n\nvec3 background(in vec3 dir) {\n    vec3 ac = vec3(101.,133.,162.) / 255.;\n\treturn ac + sun.color * pow(max(0., dot(dir, sun.dir)), 40.);\n}\n\nvec3 light(in vec3 at, in vec3 from, in light_dir_t l) {\n\tvec3 n = normal(at), h = normalize(from + l.dir);\n\t//if (trace(ray_t(at+n*1., l.dir), 3000.) < 3000.) return vec3(0.);\n\treturn l.color * (\n\t\tcmat.diffuse * max(0., dot(n, l.dir))\n\t\t+ pow(max(0., dot(n, h)), cmat.specular) * (cmat.specular + 8.) / (8. * c_pi));\n}\n\nvoid update_mat(in vec3 at) {\n\tfloat h = at.y;// + 30. * (noise_value(at.zx*.00002) - .5);\n\tif (h < 125.) {\n\t\tcmat.diffuse = vec3(.2, .4, .9);\n\t\tcmat.specular = 30.;\n\t} else if(h < 150.) {\n\t\tcmat.diffuse = vec3(.8, .8, .2);\n\t} else if(h < 220.) {\n\t\tcmat.diffuse = vec3(.8, .9, .2);\n\t} else if(h > 400.) {\n\t\tcmat.diffuse = vec3(1.);\n\t} else {\n\t\tcmat.specular = 10000.;\n\t}\n}\n//---------------------------------------------------------\nvoid main() {\t\n\tt = time * .5;\n\t// Calculate normalized and aspect-corrected pixel position \n\tfloat aspect = resolution.x / resolution.y;\n\tvec2 uv = (gl_FragCoord.xy / resolution.xy * 2. - 1.) * vec2(aspect, 1.);\n\t\n\tray_t ray;\n\tif (mouse.x <= 0.5) {\n\t\tfloat s = sin(-t*.2), c = cos(t*.2);\n\t\tmat3 r = mat3(c, 0., -s, 0., 1., 0., s, 0., c);\n\t\tvec3 at = vec3(1500.*t, 0., 0.);\n\t\tvec3 pos = at + r * (vec3(5000.,4000.,8000.)*(1.1 + sin(t*.5)));\n\t\tray = lookAtDir(normalize(vec3(uv, 2.)), pos, at+vec3(0., 2000.*sin(t), 0.));\n\t} else {\n\t\tvec2 mp = mouse / resolution;\n\t\tfloat a = 2. * c_pi * mp.x;\n\t\tfloat s = sin(a), c = cos(a);\n\t\tmat3 r = mat3(c, 0., -s, 0., 1., 0., s, 0., c);\n\t\tray = lookAtDir(normalize(vec3(uv, 2.)),\n\t\t \t\t\t  vec3(1500.*t, 0. ,0.)+r*vec3(6000.,100.+6000.*(1.-mp.y),6000.),\n\t\t\t\t\t  vec3(1500.*t, 0. ,0.));\n\t}\n\n\tray.origin.y = max(terrain_height(ray.origin)+10., ray.origin.y);\n\tfloat path = trace(ray, MAX_DISTANCE);\n\n\tvec3 color = vec3(0.);\n\taccum.a = min(accum.a, 1.);\n\tif (solid > 0.) {\n\t\tvec3 at = RT(ray,path);\n\t\tupdate_mat(at);\n\t\tcolor = light(at, -ray.dir, sun);\n\t} else {\n\t\tcolor = accum.rgb;\n\t}\n\n    float klen = clamp(pow(path / MAX_DISTANCE, 2.), 0., 1.);\n\tcolor = mix(color, background(ray.dir), klen) * (1.-accum.a) + accum.rgb;\n    color += .64 * sun.color * pow(max(0., dot(ray.dir, sun.dir)), 2.);\n\n    gl_FragColor = vec4(color, 1.0);\n}\n\n", "user": "2c3f934", "parent": null, "id": "26146.1"}