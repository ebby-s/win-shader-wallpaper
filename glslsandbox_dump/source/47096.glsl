{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n\n// Bonzomatic's default shader translated to glsl sandbox format\n\n\nfloat fGlobalTime;\nvec2 v2Resolution;\n\nvec4 out_color;\n\n\n// ________________________________________\n\n\n// pallerokokeilu numero 10\n\n\nvec3 lipo = vec3(0.3, 3.0, 0.0), //  + vec3(sin(time*3.0)*10.0, 30.0, -2.0), // light position\n  lico = vec3(1.0, 0.7, 1.9); // light color\n\n\nfloat sphere(vec3 p, float r)\n{\n  return length(p) - r;\n}\n\nvec2 matmin(vec2 mm, float d, float m)\n{\n  if (d < mm.x) \n    return vec2(d, m);\n  else\n    return mm;\n}\n\n\nvec3 rd=vec3(0.0, 0.0, 1.0);\n\nfloat df(vec3 p, out float mat)\n{\n  float f=-3.0;\n  float fy=f-p.y, fz=fy*rd.z/rd.y;\n  \n  vec2 r = vec2(29.0-length(p), -2.0); // big outer sphere\n  float dfloor=sqrt(fy*fy+fz*fz) * sign(p.y-f);\n  r = matmin(r, dfloor, -1.0);\n\n  \n  for (float i=0.0; i<11.0; i+=1.0)\n  {\n    float t = mod(time*(1.8+i*.2), 2.0) - 1.0;\n    float x = i * 4.0 - 11.0*4.0*0.5;\n    float y = - t*t;\n    float z = 20.0 + sin(time*1.4 + i) * 4.0;\n\n    r = matmin(r, sphere(p - vec3(x,y,z), 3.0), i);\n  }\n\n  mat=r.y;\n  return r.x;\n}\n\nfloat shade(vec3 p)\n{\n  float r = 1.0, s=1.5;\n  vec3 lv=normalize(lipo-p);\n  p+=lv*s;\n  for (float i=0.0; i<10.0; i+=1.0) {\n    float dummy, d=df(p, dummy);\n    if (d<s) {\n      r = min(r, d/s);\n    }\n  }\n  return r;\n}\n\n\nvoid main(void)\n{\n\tfGlobalTime = time; // in seconds\n\tv2Resolution = resolution; // viewport resolution (in pixels)\n\t\n  vec2 uv = vec2(gl_FragCoord.x / v2Resolution.x, gl_FragCoord.y / v2Resolution.y);\n  uv -= 0.5;\n  uv /= vec2(v2Resolution.y / v2Resolution.x, 1);\n\n  vec3 \n    ro = vec3(0.0), sp=vec3(uv, 1.0),\n    l = vec3(0.0), p=ro;\n\n  rd=normalize(sp-ro);\n\n  float contrib = 1.0;\n  for(float i=0.0;i<120.0;i+=1.0) {\n    float mat;\n    float d=df(p, mat);\n    if (d<0.0) { p+=d*rd; d=0.0; }\n    if (d<0.000005) {\n      vec3 e=vec3(0.01, 0.0, 0.0);\n      float dummy;\n      vec3 norm=normalize(vec3(df(p-e.xyy, dummy), df(p-e.yxy, dummy), df(p-e.yyx, dummy)));\n      vec3 lv=normalize(p-lipo);\n\n      vec3 m=vec3(1.0);\n      if (mat<0.0) m=vec3(1.0+mat*.5); // mod(p.x, 1.0)+mod(p.z, 1.0));\n      else\n        m=vec3(mod(mat*.4323, 1.0), mod(mat*1.7, 1.0), mod(mat*0.57,1.0));\n      l = mix(l, (shade(p)*dot(lv, norm)+0.01)*lico*m*3.0/(log(length(p))), contrib);\n      contrib *= 0.4;\n      if (contrib < 0.01) break;\n      rd=reflect(rd, norm);\n      p+=rd*0.0001;\n    } else {\n      p+=rd*d; // *0.999;\n    }\n  }\n\n  out_color = vec4(l, 1.0);\n\n  gl_FragColor = out_color;\n}", "user": "bb07244", "parent": null, "id": 47096}