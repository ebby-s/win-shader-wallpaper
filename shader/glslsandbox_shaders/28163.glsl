{"code": "// Fractals: MRS\n// by Nikos Papadopoulos, 4rknova / 2015\n// Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.\n//\n// Adapted from https://www.shadertoy.com/view/4lSSRy by J.\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n\n    vec2 uv = .275 * gl_FragCoord.xy / resolution.y;\n    float t = time*.03, k = cos(t), l = sin(t);        \n    \n    float s = .2;\n    for(int i=0; i<64; ++i) {\n        uv  = abs(uv) - s;    // Mirror\n        uv *= mat2(k,-l,l,k); // Rotate\n        s  *= .95156;         // Scale\n    }\n    \n    float x = .5 + .5*cos(6.28318*(40.*length(uv)));\n    gl_FragColor = vec4(vec3(x),1);\n}", "user": "d39f670", "parent": null, "id": "28163.0"}