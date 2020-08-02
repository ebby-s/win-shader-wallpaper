
precision mediump float;

//uniform vec4 frag[11];
uniform sampler2D tex;
//varying vec2 ftcoord;
//varying vec2 fpos;

uniform vec2 resolution;
varying vec2 surfacePosition;
#define ftcoord (gl_FragCoord.xy/resolution)
#define fpos surfacePosition


#define scissorMat mat3(vec3(1,0,0), vec3(0,1,0), vec3(0,0,1))
#define paintMat mat3(vec3(1,0,0), vec3(0,1,0), vec3(0,0,1))
#define innerCol vec4(1)
#define outerCol vec4(0)
#define scissorExt vec2(.9)
#define scissorScale vec2(1)
#define extent vec2(1)
#define radius 0.5
#define feather 0.05
#define strokeMult 1.
#define strokeThr 1.
#define texType 0
#define type 0


float sdroundrect(vec2 pt, vec2 ext, float rad) {
    vec2 ext2 = ext - vec2(rad,rad);
    vec2 d = abs(pt) - ext2;
    return min(max(d.x,d.y),0.0) + length(max(d,0.0)) - rad;
}

// Scissoring
float scissorMask(vec2 p) {
    vec2 sc = (abs((scissorMat * vec3(p,1.0)).xy) - scissorExt);
    sc = vec2(0.5,0.5) - sc * scissorScale;
    return clamp(sc.x,0.0,1.0) * clamp(sc.y,0.0,1.0);
}


void main() {
    vec4 result;
    float scissor = scissorMask(fpos);

    float strokeAlpha = 1.0;

    if (type == 0) {                        // Gradient
               // Calculate gradient color using box gradient
               vec2 pt = (paintMat * vec3(fpos,1.0)).xy;
               float d = clamp((sdroundrect(pt, extent, radius) + feather*0.5) / feather, 0.0, 1.0);
               vec4 color = mix(innerCol,outerCol,d);
               // Combine alpha
               color *= strokeAlpha * scissor;
               result = color;
    } else if (type == 1) {         // Image
               // Calculate color fron texture
               vec2 pt = (paintMat * vec3(fpos,1.0)).xy / extent;
               vec4 color = texture2D(tex, pt);
               if (texType == 1) color = vec4(color.xyz*color.w,color.w);
               if (texType == 2) color = vec4(color.x);
               // Apply color tint and alpha.
               color *= innerCol;
               // Combine alpha
               color *= strokeAlpha * scissor;
               result = color;
    }
    else if (type == 2) {         // Stencil fill
               result = vec4(1,1,1,1);
    } else if (type == 3) {         // Textured tris
               vec4 color = texture2D(tex, ftcoord);
               if (texType == 1) color = vec4(color.xyz*color.w,color.w);
               if (texType == 2) color = vec4(color.x);
               color *= scissor;
               result = color * innerCol;
    }
    gl_FragColor = result;
}