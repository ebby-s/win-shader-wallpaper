
for i in range(46922, 47521):
    raw = open("glslsandbox_dump\source\%d.glsl" % i)

    file = raw.readline()
    file = file.split('", "')
    code = file[0].split('": "')[1]

    code = code.replace("\\n", "\n")
    code = code.replace("\\t", " ")

    out = open("glslsandbox_dump\source\%d.glsl" % i,"w")
    out.write(code)
    out.close()
