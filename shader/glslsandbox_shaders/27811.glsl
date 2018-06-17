{"code": "\n#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform vec2 resolution;\nuniform float time;\n\n//Simple raymarching sandbox with camera\n\n//Raymarching Distance Fields\n//About http://www.iquilezles.org/www/articles/raymarchingdf/raymarchingdf.htm\n//Also known as Sphere Tracing\n\n//Util Start\nvec2 ObjUnion(in vec2 obj0,in vec2 obj1){\n    if (obj0.x<obj1.x)\n        return obj0;\n    else\n        return obj1;\n}\n//Util End\n\n//Scene Start\n\n//Floor\nvec2 obj0(in vec3 p){\n    //obj deformation\n    p.y=p.y+sin(sqrt(p.x*p.x+p.z*p.z)-time*4.0)*0.5;\n    //plane\n    \n    return vec2(p.y+3.0,0);\n}\n//Floor Color (checkerboard)\nvec3 obj0_c(in vec3 p){\n    if (fract(p.x*.5)>.5)\n        if (fract(p.z*.5)>.5)\n            return vec3(0,0,0);\n        else\n            return vec3(2,1,1);\n        else\n            if (fract(p.z*.5)>.5)\n                return vec3(1,1,1);\n            else\n                return vec3(0,0,0);\n}\n\n//IQs RoundBox (try other objects http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm)\nvec2 obj1(in vec3 p){\n    //obj deformation\n    p.y=3.5+p.y+sin(sqrt(p.x*p.x+p.z*p.z)-time*2.0)*0.5;\n    p.x=fract(p.x+0.5)-0.5;\n    p.z=fract(p.z+0.5)-0.5;\n    //p.y=p.y-1.0+sin(time*6.0);\n    return vec2(length(max(abs(p)-vec3(0.125,0.125,0.125),0.0))-0.205,1);\n}\n\n//RoundBox with simple solid color\nvec3 obj1_c(in vec3 p){\n    return vec3(1.0,sin(p.x*0.2),sin(p.z*0.2));\n}\n\n//Objects union\nvec2 inObj(in vec3 p){\n    return ObjUnion(obj0(p),obj1(p));\n}\n\n//Scene End\n\nvoid main(void){\n    vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;\n    \n    //Camera animation\n    vec3 vuv=vec3(0,1,sin(time*0.1));//Change camere up vector here\n    vec3 prp=vec3(-sin(time*0.6)*8.0,-1,cos(time*0.4)*8.0); //Change camera path position here\n    vec3 vrp=vec3(0,0,0); //Change camere view here\n    \n    \n    //Camera setup\n    vec3 vpn=normalize(vrp-prp);\n    vec3 u=normalize(cross(vuv,vpn));\n    vec3 v=cross(vpn,u);\n    vec3 vcv=(prp+vpn);\n    vec3 scrCoord=vcv+vPos.x*u*resolution.x/resolution.y+vPos.y*v;\n    vec3 scp=normalize(scrCoord-prp);\n    \n    //Raymarching\n    const vec3 e=vec3(0.1,0,0);\n    const float maxd=60.0; //Max depth\n    \n    vec2 s=vec2(0.1,0.0);\n    vec3 c,p,n;\n    \n    float f=1.0;\n    for(int i=0;i<256;i++){\n        if (abs(s.x)<.01||f>maxd) break;\n        f+=s.x;\n        p=prp+scp*f;\n        s=inObj(p);\n    }\n    \n    if (f<maxd){\n        if (s.y==0.0)\n            c=obj0_c(p);\n        else\n            c=obj1_c(p);\n        n=normalize(\n                    vec3(s.x-inObj(p-e.xyy).x,\n                         s.x-inObj(p-e.yxy).x,\n                         s.x-inObj(p-e.yyx).x));\n        float b=dot(n,normalize(prp-p));\n        gl_FragColor=vec4((b*c+pow(b,8.0))*(1.0-f*.02),1.0);//simple phong LightPosition=CameraPosition\n    }\n    else gl_FragColor=vec4(0,0,0,1); //background color\n}", "user": "704a2c2", "parent": null, "id": "27811.1"}