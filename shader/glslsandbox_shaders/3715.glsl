{"code": "//original author = ?\n//fork by tigrou(ind) : repeat gears over x/y axis, add more colors\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n\n\tvec2 distanceVector = (gl_FragCoord.xy / resolution.xy);\n\tdistanceVector.x *= resolution.x;\n\tdistanceVector.y *= resolution.y;\n\t\n\tfloat d = 135.0;\n\t\n\tfloat newtime = time * sign(mod(distanceVector.x, d * 2.0) - d) * sign(mod(distanceVector.y, d * 2.0) - d);\n\t\n\tdistanceVector.x = mod(distanceVector.x, d) - d / 2.0;\t\n\tdistanceVector.y = mod(distanceVector.y, d) - d / 2.0;\n\t\n\tfloat angle = atan(distanceVector.x, distanceVector.y);\n\t\n\tfloat scale = 0.0002;\n\tfloat cogMin = 0.02; // 'min' is actually the outer edge because I'm using 1/distance... for reasons I can't remember :(\n\tfloat cogMax = 0.7; // 'max' is the inner edge, so this controls the size of the hole in the middle - the higher the value the smaller the hole\n\n\n\tfloat distance = 1.0 - scale * ((distanceVector.x * distanceVector.x) + (distanceVector.y * distanceVector.y));\n\n\t\n\t// tooth adjust makes the teeth slope so they get smaller as they get further out\n\tfloat toothAdjust = 2.4 * (distance - cogMin);\n\t// 12 defines the number of cog teeth\n\tfloat angleFoo = sin(angle*6.0 - newtime * 4.0) - toothAdjust;\n\tcogMin += 40.0 * clamp(1.0 * (angleFoo + 0.3), 0.0, 0.01); // add 0.2 to make teeth a bit thinner, the 0.015 clamp controls the thickness of the cog ring\n\t\n\t// By multiplying values up and clamping we can get a solid cog with slight anti-aliasing\n\tfloat isSolid = clamp(2.0 * (distance - cogMin) / cogMax, 0.0, 1.0);\n\tisSolid = clamp(isSolid * 100.0 * (cogMax - distance), 0.0, 1.0);\n\t\n\t// Make it BlitzTech purple\t\n\tfloat brightness = isSolid *(1.0-sin(angle*6.0-newtime)*0.25);\n\tgl_FragColor = vec4(brightness*0.5,brightness*0.25,brightness*0.5 * sign(newtime), 1.0 );\n}", "user": "38db6be", "parent": "/e#2317.0", "id": "3715.0"}