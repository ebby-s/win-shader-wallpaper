{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n\n\tvec2 position = ( gl_FragCoord.xy / resolution.xy ) + 2.5;\n\t\n\t\n\tposition.x += sin(position.y * cos(time) * 0.05) * 0.05;\n\n\tfloat color = 0.0;\n\tcolor += 1.0 * (sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 )+ dot(-position, position));\n\tcolor += 1.0 * ( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );\n\tcolor += 1.0 * (sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 ));\n\tcolor *= 1.0 * (sin( time / 10.0 ) * 0.5);\n\n\tgl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );\n\n}", "user": "e81494a", "parent": null, "id": 47516}