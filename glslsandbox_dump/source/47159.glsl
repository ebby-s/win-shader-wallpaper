{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n// Modified version of https://www.shadertoy.com/view/MstXWn\n\n// cd publi http://evasion.imag.fr/~Fabrice.Neyret/flownoise/index.gb.html\n//          http://mrl.nyu.edu/~perlin/flownoise-talk/\n\n// The raw principle is trivial: rotate the gradients in Perlin noise.\n// Complication: checkboard-signed direction, hierarchical rotation speed (many possibilities).\n// Not implemented here: pseudo-advection of one scale by the other.\n\n// --- Perlin noise by inigo quilez - iq/2013   https://www.shadertoy.com/view/XdXGW8\nvec2 hash( vec2 p )\n{\n\tp = vec2( dot(p,vec2(127.1,311.7)),\n\t\t\t  dot(p,vec2(269.5,183.3)) );\n\n\treturn -1.0 + 2.0*fract(sin(p)*43758.5453123);\n}\n\nfloat level=1.;\nfloat noise( in vec2 p )\n{\n    vec2 i = floor( p );\n    vec2 f = fract( p );\n\t\n\tvec2 u = f*f*f*(10. + f*(6.*f - 15.));\n\n\n    float t = 1.0*time;\n    mat2 R = mat2(cos(t),-sin(t),sin(t),cos(t));\n//    if (mod(i.x+i.y,2.)==0.) R=-R;\n\n    return 2.*mix( mix( dot( hash( i + vec2(0,0) )*R, (f - vec2(0,0)) ), \n                     dot( hash( i + vec2(1,0) )*R,(f - vec2(1,0)) ), u.x),\n                mix( dot( hash( i + vec2(0,1) )*R,(f - vec2(0,1)) ), \n                     dot( hash( i + vec2(1,1) )*R, (f - vec2(1,1)) ), u.x), u.y);\n}\n\nfloat Mnoise(in vec2 uv ) {\n    return noise(uv);                      // base turbulence\n  //return -1. + 2.* (1.-abs(noise(uv)));  // flame like\n    //return -1. + 2.* (abs(noise(uv)));     // cloud like\n}\n\nfloat turb( in vec2 uv )\n{ \tfloat f = 0.0;\n\t\n level=1.;\n    mat2 m = mat2( 1.6,  1.2, -1.2,  1.6 );\n    f  = 0.5000*Mnoise( uv ); uv = m*uv; level++;\n\t//f += 0.2500*Mnoise( uv ); uv = m*uv; level++;\n\t//f += 0.1250*Mnoise( uv ); uv = m*uv; level++;\n\t//f += 0.0625*Mnoise( uv ); uv = m*uv; level++;\n\treturn f/.9375; \n}\n// -----------------------------------------------\n\nvoid main( void ) {\n    vec2 uv = gl_FragCoord.xy / resolution.y,\n         m = mouse.xy /  resolution.y;\n    if (length(m)==0.) m = vec2(.5);\n\t\n\tfloat f; \n  //f = Mnoise( 5.*uv );\n    f = turb( 5.*uv );\n\tgl_FragColor = vec4(.5 + .5* f);\n    gl_FragColor = mix(vec4(0,0,.3,1),vec4(1.3),gl_FragColor); \n}\n\n", "user": "b38120a", "parent": null, "id": 47159}