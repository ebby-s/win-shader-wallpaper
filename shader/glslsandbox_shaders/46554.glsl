{"code": "/*\n * Original shader from: https://www.shadertoy.com/view/Ms3BzN\n */\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n// glslsandbox uniforms\nuniform float time;\nuniform vec2 resolution;\n\n// shadertoy globals\nfloat iTime;\nvec3  iResolution;\n\n// --------[ Original ShaderToy begins here ]---------- //\n// The MIT License\n// Copyright \u00c2\u00a9 2018 Charles Durham, 2014 Inigo Quilez\n// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n\n// Stolen hsl2rgb function from https://www.shadertoy.com/view/lsS3Wc\n\n//========================================================================\n\nvec3 hsl2rgb( in vec3 c )\n{\n    vec3 rgb = clamp( abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );\n    return c.z + c.y * (rgb-0.5)*(1.0-abs(2.0*c.z-1.0));\n}\n\nvec3 color(in vec2 p)\n{\n    float pi = 3.141593;\n    float theta = atan(p.y,p.x);\n    float h = theta/(2.0*pi);\n    float s = 0.5;\n    float v = 0.6*length(p);\n    vec3 hsv = vec3 (h,s,v);\n    return hsl2rgb(hsv);\n}\n\nvec2 func(in vec3 p)\n{\n    float x = p.x;\n    float y = p.y;\n    float t = p.z;\n    float f = sin(2.0*sin(0.02*t)*y - 3.0*cos(0.03*t)*x)*exp(-abs (sin(0.11*t)*sin (3.0*x+1.0-2.0*y) - sin(0.19*t)*cos(x-3.0*y+1.0)));\n    float g = cos(2.0*sin(0.07*t)*y - 3.0*cos(0.05*t)*x)*exp(-abs (cos(0.13*t)*cos (3.0*x+1.0-2.0*y) - cos(0.17*t)*cos(x-3.0*y+1.0)));\n    return vec2(f,g);\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n    // Normalized pixel coordinates (from 0 to 1)\n    vec2 uv = fragCoord/iResolution.xy;\n    \n    //Stretch to be between from -4 to 4\n    float h = 4.0;\n    uv = vec2(h*2.0)*uv - vec2(h);\n    \n    //Scale time by 10\n    float t = iTime * 10.0;\n    \n    uv = func(vec3(uv,t));\n\n    vec3 col = color(uv);\n\n    fragColor = vec4(col,1.0);\n}\n\n\n// --------[ Original ShaderToy ends here ]---------- //\n\nvoid main(void)\n{\n    iTime = time;\n    iResolution = vec3(resolution, 0.0);\n\n    mainImage(gl_FragColor, gl_FragCoord.xy);\n}", "user": "c15437", "parent": null, "id": "46554.0"}