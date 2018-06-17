{"code": "precision highp float;\n\nuniform float time;\nuniform vec2 resolution;\nuniform vec2 mouse;\n\nmat3 genRotMat(float a0,float x,float y,float z){\nfloat a=a0*3.1415926535897932384626433832795/180.0;\n  return mat3(\n    1.0+(1.0-cos(a))*(x*x-1.0),\n    -z*sin(a)+(1.0-cos(a))*x*y,\n    y*sin(a)+(1.0-cos(a))*x*z,\n    z*sin(a)+(1.0-cos(a))*x*y,\n    1.0+(1.0-cos(a))*(y*y-1.0),\n    -x*sin(a)+(1.0-cos(a))*y*z,\n    -y*sin(a)+(1.0-cos(a))*x*z,\n    x*sin(a)+(1.0-cos(a))*y*z,\n    1.0+(1.0-cos(a))*(z*z-1.0)\n  );\n}\n\nfloat cubeDist(vec3 p){\n  return max(abs(p.x),max(abs(p.y),abs(p.z)));\n}\n\nvoid main(){\n  float spread=1.0;\n  float total=0.0;\n  float delta=0.01;\n  float cameraZ=-1.75;\n  float nearZ=-1.0;\n  float farZ=1.0;\n  float gs=0.0;\n  int iter=0;\n  vec3 col=vec3(0.0,0.0,0.0);\n  vec3 ray=vec3(0.0,0.0,0.0);\n  mat3 rot=genRotMat(sin(time/4.13)*360.0,1.0,0.0,0.0);\n  rot=rot*genRotMat(sin(time/4.64)*360.0,0.0,1.0,0.0);\n  rot=rot*genRotMat(sin(time/4.24)*360.0,0.0,0.0,1.0);\n  vec2 p=vec2(0.0,0.0);\n  p.x=gl_FragCoord.x/resolution.y-0.5*resolution.x/resolution.y;\n  p.y=gl_FragCoord.y/resolution.y-0.5;\n  ray.xy+=p.xy*spread*(nearZ-cameraZ);\n  vec3 rayDir=vec3(spread*p.xy*delta,delta);\n  vec3 tempDir=rayDir*rot;\n  vec3 norm;\n  ray.z=nearZ;\n\tbool refracted=false;\n  for(int i=0;i<250;i++){\n    vec3 temp;\n    vec3 tempc;\n    float val;\n    temp=ray.xyz*rot;\n    tempc=temp;\n    float thres=0.5;\n    if(tempc.x<0.0)tempc.x=abs(tempc.x);\n    if(tempc.x<thres)tempc.x=0.0;\n    else tempc.x=1.0/tempc.x*sin(time);\n    if(tempc.y<0.0)tempc.y=abs(tempc.y);\n    if(tempc.y<thres)tempc.y=0.0;\n    else tempc.y=1.0/tempc.y*sin(time*0.842);\n    if(tempc.z<0.0)tempc.z=abs(tempc.z);\n    if(tempc.z<thres)tempc.z=0.0;\n    else tempc.z=1.0/tempc.z*sin(time*1.132);\n    val=cubeDist(temp);\n\t  if(val<thres && !refracted){\n\t\t  rayDir=vec3(0.5*spread*p.xy*delta,delta);\n\t\t  refracted=true;\n\t    }\n    if(val<0.0)val=abs(val);\n    if(val<thres)val=0.0;\n    else val=1.0/val;\n    col.x+=(val+tempc.x)/2.0;\n    col.y+=(val+tempc.y)/2.0;\n    col.z+=(val+tempc.z)/2.0;\n    ray+=rayDir;\n    iter++;\n    if(ray.z>=farZ)break;\n  }\n  col.x=col.x/float(iter);\n  col.y=col.y/float(iter);\n  col.z=col.z/float(iter);\n  gl_FragColor=vec4(col,1.0);\n}", "user": "273e418", "parent": null, "id": "4278.1"}