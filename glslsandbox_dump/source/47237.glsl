{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n//\n// Description : Array and textureless GLSL 2D/3D/4D simplex \n//               noise functions.\n//      Author : Ian McEwan, Ashima Arts.\n//  Maintainer : ijm\n//     Lastmod : 20110822 (ijm)\n//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.\n//               Distributed under the MIT License. See LICENSE file.\n//               https://github.com/ashima/webgl-noise\n// \n\nvec3 mod289(vec3 x) {\n\treturn x - floor(x * (1.0 / 289.0)) * 289.0;\n}\n\nvec4 mod289(vec4 x) {\n\treturn x - floor(x * (1.0 / 289.0)) * 289.0;\n}\n\nvec4 permute(vec4 x) {\n\treturn mod289(((x*34.0)+1.0)*x);\n}\n\nvec4 taylorInvSqrt(vec4 r){\n\treturn 1.79284291400159 - 0.85373472095314 * r;\n}\n\nfloat snoise(vec3 v) { \n\n\tconst vec2  C = vec2(1.0/6.0, 1.0/3.0) ;\n\tconst vec4  D = vec4(0.0, 0.5, 1.0, 2.0);\n\n\t// First corner\n\tvec3 i  = floor(v + dot(v, C.yyy) );\n\tvec3 x0 =   v - i + dot(i, C.xxx) ;\n\n\t// Other corners\n\tvec3 g = step(x0.yzx, x0.xyz);\n\tvec3 l = 1.0 - g;\n\tvec3 i1 = min( g.xyz, l.zxy );\n\tvec3 i2 = max( g.xyz, l.zxy );\n\n\t//   x0 = x0 - 0.0 + 0.0 * C.xxx;\n\t//   x1 = x0 - i1  + 1.0 * C.xxx;\n\t//   x2 = x0 - i2  + 2.0 * C.xxx;\n\t//   x3 = x0 - 1.0 + 3.0 * C.xxx;\n\tvec3 x1 = x0 - i1 + C.xxx;\n\tvec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y\n\tvec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y\n\n\t// Permutations\n\ti = mod289(i); \n\tvec4 p = permute( permute( permute( \n\t\t  i.z + vec4(0.0, i1.z, i2.z, 1.0 ))\n\t\t+ i.y + vec4(0.0, i1.y, i2.y, 1.0 )) \n\t\t+ i.x + vec4(0.0, i1.x, i2.x, 1.0 ));\n\n\t// Gradients: 7x7 points over a square, mapped onto an octahedron.\n\t// The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)\n\tfloat n_ = 0.142857142857; // 1.0/7.0\n\tvec3  ns = n_ * D.wyz - D.xzx;\n\n\tvec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)\n\n\tvec4 x_ = floor(j * ns.z);\n\tvec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)\n\n\tvec4 x = x_ *ns.x + ns.yyyy;\n\tvec4 y = y_ *ns.x + ns.yyyy;\n\tvec4 h = 1.0 - abs(x) - abs(y);\n\n\tvec4 b0 = vec4( x.xy, y.xy );\n\tvec4 b1 = vec4( x.zw, y.zw );\n\n\t//vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;\n\t//vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;\n\tvec4 s0 = floor(b0)*2.0 + 1.0;\n\tvec4 s1 = floor(b1)*2.0 + 1.0;\n\tvec4 sh = -step(h, vec4(0.0));\n\n\tvec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;\n\tvec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;\n\n\tvec3 p0 = vec3(a0.xy,h.x);\n\tvec3 p1 = vec3(a0.zw,h.y);\n\tvec3 p2 = vec3(a1.xy,h.z);\n\tvec3 p3 = vec3(a1.zw,h.w);\n\n\t//Normalise gradients\n\tvec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));\n\tp0 *= norm.x;\n\tp1 *= norm.y;\n\tp2 *= norm.z;\n\tp3 *= norm.w;\n\n\t// Mix final noise value\n\tvec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);\n\tm = m * m;\n\treturn 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3) ) );\n\n}\n\nvec3 snoiseVec3( vec3 x ){\n\n\tfloat s  = snoise(vec3( x ));\n\tfloat s1 = snoise(vec3( x.y - 19.1 , x.z + 33.4 , x.x + 47.2 ));\n\tfloat s2 = snoise(vec3( x.z + 74.2 , x.x - 124.5 , x.y + 99.4 ));\n\tvec3 c = vec3( s , s1 , s2 );\n\treturn c;\n\n}\n\nvec3 snoiseVec3Abs( vec3 x ){\n\n\tfloat s  = snoise(vec3( x ));\n\tfloat s1 = snoise(vec3( x.y - 19.1 , x.z + 33.4 , x.x + 47.2 ));\n\tfloat s2 = snoise(vec3( x.z + 74.2 , x.x - 124.5 , x.y + 99.4 ));\n\tvec3 c = vec3( abs(s) , abs(s1) , abs(s2) );\n\treturn c;\n\n}\n\n\nvec3 curlNoise( vec3 p ){\n \n\tconst float e = .1;\n\tvec3 dx = vec3( e   , 0.0 , 0.0 );\n\tvec3 dy = vec3( 0.0 , e   , 0.0 );\n\tvec3 dz = vec3( 0.0 , 0.0 , e   );\n\n\tvec3 p_x0 = snoiseVec3( p - dx );\n\tvec3 p_x1 = snoiseVec3( p + dx );\n\tvec3 p_y0 = snoiseVec3( p - dy );\n\tvec3 p_y1 = snoiseVec3( p + dy );\n\tvec3 p_z0 = snoiseVec3( p - dz );\n\tvec3 p_z1 = snoiseVec3( p + dz );\n\n\tfloat x = p_y1.z - p_y0.z - p_z1.y + p_z0.y;\n\tfloat y = p_z1.x - p_z0.x - p_x1.z + p_x0.z;\n\tfloat z = p_x1.y - p_x0.y - p_y1.x + p_y0.x;\n\n\tconst float divisor = 1.0 / ( 2.0 * e );\n\treturn normalize( vec3( x , y , z ) * divisor );\n\n}\n\nvec3 curlNoise2( vec3 p ) {\n\n\tconst float e = .1;\n\n\tvec3 xNoisePotentialDerivatives = snoiseVec3( p );\n\tvec3 yNoisePotentialDerivatives = snoiseVec3( p + e * vec3( 3., -3.,  1. ) );\n\tvec3 zNoisePotentialDerivatives = snoiseVec3( p + e * vec3( 2.,  4., -3. ) );\n\n\tvec3 noiseVelocity = vec3(\n\t\tzNoisePotentialDerivatives.y - yNoisePotentialDerivatives.z,\n\t\txNoisePotentialDerivatives.z - zNoisePotentialDerivatives.x,\n\t\tyNoisePotentialDerivatives.x - xNoisePotentialDerivatives.y\n\t);\n\n\treturn normalize( noiseVelocity );\n\n}\n\nvec4 snoiseD(vec3 v) { //returns vec4(value, dx, dy, dz)\n  const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;\n  const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);\n \n  vec3 i  = floor(v + dot(v, C.yyy) );\n  vec3 x0 =   v - i + dot(i, C.xxx) ;\n \n  vec3 g = step(x0.yzx, x0.xyz);\n  vec3 l = 1.0 - g;\n  vec3 i1 = min( g.xyz, l.zxy );\n  vec3 i2 = max( g.xyz, l.zxy );\n \n  vec3 x1 = x0 - i1 + C.xxx;\n  vec3 x2 = x0 - i2 + C.yyy;\n  vec3 x3 = x0 - D.yyy;\n \n  i = mod289(i);\n  vec4 p = permute( permute( permute(\n             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))\n           + i.y + vec4(0.0, i1.y, i2.y, 1.0 ))\n           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));\n \n  float n_ = 0.142857142857; // 1.0/7.0\n  vec3  ns = n_ * D.wyz - D.xzx;\n \n  vec4 j = p - 49.0 * floor(p * ns.z * ns.z);\n \n  vec4 x_ = floor(j * ns.z);\n  vec4 y_ = floor(j - 7.0 * x_ );\n \n  vec4 x = x_ *ns.x + ns.yyyy;\n  vec4 y = y_ *ns.x + ns.yyyy;\n  vec4 h = 1.0 - abs(x) - abs(y);\n \n  vec4 b0 = vec4( x.xy, y.xy );\n  vec4 b1 = vec4( x.zw, y.zw );\n \n  vec4 s0 = floor(b0)*2.0 + 1.0;\n  vec4 s1 = floor(b1)*2.0 + 1.0;\n  vec4 sh = -step(h, vec4(0.0));\n \n  vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;\n  vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;\n \n  vec3 p0 = vec3(a0.xy,h.x);\n  vec3 p1 = vec3(a0.zw,h.y);\n  vec3 p2 = vec3(a1.xy,h.z);\n  vec3 p3 = vec3(a1.zw,h.w);\n \n  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));\n  p0 *= norm.x;\n  p1 *= norm.y;\n  p2 *= norm.z;\n  p3 *= norm.w;\n \n  vec4 values = vec4( dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3) ); //value of contributions from each corner (extrapolate the gradient)\n \n  vec4 m = max(0.5 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0); //kernel function from each corner\n \n  vec4 m2 = m * m;\n  vec4 m3 = m * m * m;\n \n  vec4 temp = -6.0 * m2 * values;\n  float dx = temp[0] * x0.x + temp[1] * x1.x + temp[2] * x2.x + temp[3] * x3.x + m3[0] * p0.x + m3[1] * p1.x + m3[2] * p2.x + m3[3] * p3.x;\n  float dy = temp[0] * x0.y + temp[1] * x1.y + temp[2] * x2.y + temp[3] * x3.y + m3[0] * p0.y + m3[1] * p1.y + m3[2] * p2.y + m3[3] * p3.y;\n  float dz = temp[0] * x0.z + temp[1] * x1.z + temp[2] * x2.z + temp[3] * x3.z + m3[0] * p0.z + m3[1] * p1.z + m3[2] * p2.z + m3[3] * p3.z;\n \n  return vec4(dot(m3, values), dx, dy, dz) * 42.0;\n}\n\n\nvec3 curlNoise3 (vec3 p) {\n\n    vec3 xNoisePotentialDerivatives = snoiseD( p ).yzw; //yzw are the xyz derivatives\n    vec3 yNoisePotentialDerivatives = snoiseD(vec3( p.y - 19.1 , p.z + 33.4 , p.x + 47.2 )).zwy;\n    vec3 zNoisePotentialDerivatives = snoiseD(vec3( p.z + 74.2 , p.x - 124.5 , p.y + 99.4 )).wyz;\n    vec3 noiseVelocity = vec3(\n        zNoisePotentialDerivatives.y - yNoisePotentialDerivatives.z,\n        xNoisePotentialDerivatives.z - zNoisePotentialDerivatives.x,\n        yNoisePotentialDerivatives.x - xNoisePotentialDerivatives.y\n    );\n\t\n\tconst float e = .1;\n\tconst float divisor = 1.0 / ( 2.0 * e );\n\treturn normalize( noiseVelocity * divisor );\n\n}\n\nfloat rand(vec2 co){\n\treturn fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);\n}\n\n\n\n/////////////////////////////////////////////////////////////////////////////////////////////////\n\nvoid main( void ) {\n\n\tvec2 position = ( gl_FragCoord.xy / resolution.xy );\n\n\t//noise1\n\tvec3 vv = snoiseVec3(vec3(position.x * 3.0, position.y * 3.0+time*0.0, time*0.2)) * 8.0;\n\tvv = max(vv,0.0);\n\tvv = min(vv,1.0);\n\t\n\tfloat gray = length(vv.xxx);\n\t\n\t\n\t\n\tvec3 col = vv.xxx;\n\tvv = abs( vv.xyz );\n\t\t\t\n\t\n    \t//vec3 fragColor = vec3(0);\n\tfloat dx = dFdx(gray) * 5.0;\n\tfloat dy = dFdy(gray) * 5.0;\n\tdx = abs(dx);\n\tdy = max(dy,0.0);\n\tgl_FragColor = vec4( col - vec3(dx,dy,0), 1.0 );\n\n}", "user": "6dd2d40", "parent": "/e#47227.2", "id": 47237}