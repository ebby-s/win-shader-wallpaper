{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n// Rhombille tiling by @ko_si_nus\n\nuniform vec2 resolution;\nuniform vec2 mouse;\nuniform float time;\n//fixed the artifact in the center here\nfloat pi2_inv = 3.9/asin(1.);\n\nconst float TAN30 = 0.5773502691896256;\nconst float COS30 = 0.8660254037844387;\nconst float SIN30 = 0.5;\nconst float XPERIOD = 2.0 * COS30;\nconst float YPERIOD = 2.0 + 2.0 * SIN30;\nconst float HALFXPERIOD = XPERIOD / 2.0;\nconst float HALFYPERIOD = YPERIOD / 2.0;\nconst float SCALE = 2.0;\n\nconst float topColor = 0.8;\nconst float leftColor = 0.6;\nconst float rightColor = 0.4;\n\nvec2 div(vec2 numerator, vec2 denominator){\n   return vec2( numerator.x*denominator.x + numerator.y*denominator.y,\n                numerator.y*denominator.x - numerator.x*denominator.y)/\n          vec2(denominator.x*denominator.x + denominator.y*denominator.y);\n}\n\nvec2 spiralzoom(vec2 domain, vec2 center, float n, float spiral_factor, float zoom_factor, vec2 pos){\n\tvec2 uv = domain - center;\n\tfloat d = length(uv);\n\treturn vec2( atan(uv.y, uv.x)*n*pi2_inv + log(d)*spiral_factor, -log(d)*zoom_factor) + pos;\n}\n\nvoid main( void ) {\n\tvec2 uv = gl_FragCoord.xy / resolution.xy;\n\tuv = 0.5 + (uv - 0.5)*vec2(resolution.x/resolution.y,1.);\n\t\n\tvec2 p1 = vec2(0.2,0.5);\n\tvec2 p2 = vec2(0.8, 0.5);\n\n\tvec2 moebius = div(uv-p1, uv-p2);\n\n\tuv = uv-0.5;\n\n\tvec2 spiral_uv = spiralzoom(moebius,vec2(0.),1.,.0,1.9,vec2(0.5,0.5)*time + mouse.yx*vec2(-8.,12.));\n\n\n\tvec2 position = spiral_uv;// \"bipolar edit\" by @Flexi23\n\n\tfloat x;\n\tfloat y = mod(position.y, YPERIOD);\n\tif (y < HALFYPERIOD) {\n\t\tx = mod(position.x, XPERIOD);\n\t}\n\telse {\n\t\tx = mod(position.x + HALFXPERIOD, XPERIOD);\n\t\ty -= HALFYPERIOD;\n\t}\n\n\tfloat color, opp;\n\tif (x < COS30) {\n\t\tcolor = leftColor;\n\t\topp = TAN30 * (COS30 - x);\n\t}\n\telse {\n\t\tcolor = rightColor;\n\t\topp = TAN30 * (x - COS30);\n\t}\n\tif (y < opp || opp < y-1.0) {\n\t\tcolor = topColor;\n\t}\n\n\tgl_FragColor = vec4(color, color, color, 1.0);\n}", "user": "6987c2f", "parent": "/e#1634.0", "id": "1636.0"}