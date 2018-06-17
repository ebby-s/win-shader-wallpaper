{"code": "/*\n * Original shader from: https://www.shadertoy.com/view/4dcyWS\n */\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n// glslsandbox uniforms\nuniform float time;\nuniform vec2 resolution;\nuniform vec2 mouse;\n\n// shadertoy globals\nfloat iTime;\nvec3  iResolution;\nvec3  iMouse;\n\n// Protect glslsandbox uniform names\n#define time        stemu_time\n#define resolution  stemu_resolution\n#define mouse       stemu_mouse\n\n// --------[ Original ShaderToy begins here ]---------- //\n\n#define PI\t\t\t\t3.1415926535\n#define ABSORBANCE\t\t1.0\n//#define LIGHT_DIR\t\tnormalize(vec3(cos(-iTime*.3+PI*.5), 1.0, sin(-iTime*.3+PI*.5)))\n#define LIGHT_DIR\t\tnormalize(vec3(1., 2., 0.))\n//#define CAM_POS \t\tvec3(4.*cos(-iTime*.3), 4.0, 4.*sin(-iTime*.3))\n#define CAM_POS \t\tvec3(1.5)\n\n\nfloat yinDist(vec2 p)\n{\n    float R = 1.;    \n    float r = .15;\n    \n    float d = length(p)-R;\n    \n    d = max(d, -(length(p-vec2(0.,R*.5))-R*.5));\n    if(p.x>0.)\n    {\n    \td = max(d, length(p-vec2(0.,R)));\n        \n    \td = min(d, (length(p-vec2(0.,-R*.5))-R*.5));\n    }\n    \n    d = min(d, length(p-vec2(0., R*.5))-r);\n    d = max(d, -(length(p+vec2(0., R*.5))-r));\n    \n    \n    return -d;\n}\n\nmat2 rot(float alpha)\n{\n    return mat2(cos(alpha), sin(alpha), -sin(alpha), cos(alpha));\n}\n\n// returns the distance to the plane, and the distance to the shape in the plane\nvec2 intersectYin(vec3 ro, vec3 rd)\n{\n    vec2 res;\n    res.x = (-0.-ro.y)/rd.y;\n    //res.y = yinDist((ro+res.x*rd).xz*vec2(1., -1.));\n    res.y = yinDist((ro+res.x*rd).xz*vec2(1., -1.)*rot(iTime));\n    return res;\n}\n\nvec2 intersectYang(vec3 ro, vec3 rd)\n{\n    vec2 res;\n    res.x = (-0.-ro.x)/rd.x;\n    res.y = yinDist((ro+res.x*rd).yz*rot(iTime));\n    return res;\n}\n\nvec3 render(in vec3 ro, in vec3 rd)\n{\n    vec3 col = vec3(0.5);\n    \n    vec2 ix = intersectYin(ro, rd);\n    vec2 iy = intersectYang(ro, rd);\n    \n    float tx = ix.x;\n    float ty = iy.x;\n        \n    vec3 px = ro+tx*rd;\n    vec3 py = ro+ty*rd;\n    \n    float dx = ix.y;\n    float dy = iy.y;\n    \n    \n    vec4 colx = vec4(vec3(1.), clamp(dx/tx*iResolution.y, -1., 1.)*.5+.5);\n    vec4 coly = vec4(vec3(.1), clamp(dy/ty*iResolution.y, -1., 1.)*.5+.5);\n    \n    if(tx<0.)\n        colx.a=0.;\n    if(ty<0.)\n        coly.a=0.;\n    \n    //*\n    //-------------------------------\n    // SHADOWS\n    vec2 ixs = intersectYang(px, LIGHT_DIR);\n    vec2 iys = intersectYin(py, LIGHT_DIR);\n\n    if(ixs.x>0.)\n    {\n        //float d = ixs.y/ix.x;\n        float d = ixs.y/ix.x/ixs.x/5.;\n        colx.rgb *= 1.-.7*(clamp(d*iResolution.y, -1., 1.)*.5+.5);\n    }\n    if(iys.x>0.)\n    {\n        float d = iys.y/iy.x/iys.x/10.;\n        coly.rgb *= 1.-.7*(clamp(d*iResolution.y, -1., 1.)*.5+.5);\n    }\n    //*/\n    \n    /*\n    //-------------------------------\n    // REFLEXION\n    vec2 ixr = intersectYang(px, reflect(ro, vec3(1., 0., 0.)));\n    vec2 iyr = intersectYin (py, reflect(ro, vec3(0., 1., 0.)));\n\n    if(ixr.x>0.)\n    {\n        //float d = ixs.y/ix.x;\n        float d = ixr.y/ix.x;\n        colx.rgb = mix(colx.rgb, coly.rgb, (clamp(d*iResolution.y, -1., 1.)*.5+.5));\n    }\n\t//*/\n    \n    \n    //-------------------------------\n    // MIXING\n    if(0.<tx && tx<ty || ty<0.)\n    {\n        col = mix(col, coly.rgb, coly.a);\n        col = mix(col, colx.rgb, colx.a);\n    }\n    else if(0.<ty && ty<tx || tx<0.)\n    {\n        col = mix(col, colx.rgb, colx.a);\n        col = mix(col, coly.rgb, coly.a);\n    }\n    \n    return col;\n}\n\n\nmat3 setCamera( in vec3 ro, in vec3 ta, float cr )\n{\n\tvec3 cw = normalize(ta-ro);\n\tvec3 cp = vec3(sin(cr), cos(cr),0.0);\n\tvec3 cu = normalize( cross(cw,cp) );\n\tvec3 cv = normalize( cross(cu,cw) );\n    return mat3( cu, cv, cw );\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n    vec2 p = (-iResolution.xy + 2.0*fragCoord.xy)/ iResolution.y;\n        \n    // mouse camera control\n    float phi = (iMouse.x-0.5)/iResolution.x * PI * 2.0;\n    float psi = -((iMouse.y-0.5)/iResolution.y-0.5) * PI;\n    \n    if(iMouse.x<1.0 && iMouse.y < 1.0)\n    {\n        phi = iTime * PI * 2.0*0.1;\n        psi = cos(iTime*PI*2.0*0.1)*PI*0.25;\n    }\n    \n    // ray computation\n    vec3 ro = 2.6*vec3(cos(phi)*cos(psi), sin(psi), sin(phi)*cos(psi));\n    if(iMouse.z < 0.5)\n        ro = CAM_POS;\n    vec3 ta = vec3(0.);\n    mat3 m = setCamera(ro, ta, 0.0);\n    vec3 rd = m*normalize(vec3(p, 2.));\n    \n    // scene rendering\n    vec3 col = render( ro, rd);\n    \n    // gamma correction\n    col = sqrt(col);\n\n    fragColor = vec4(col, 1.0);\n}\n\n// --------[ Original ShaderToy ends here ]---------- //\n\n#undef time\n#undef resolution\n#undef mouse\n\nvoid main(void)\n{\n  iTime = time;\n  iResolution = vec3(resolution, 0.0);\n  iMouse = vec3(mouse * resolution, 0.0);\n\n  mainImage(gl_FragColor, gl_FragCoord.xy);\n}", "user": "16c2ef9", "parent": null, "id": "45635.0"}