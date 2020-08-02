precision mediump float;

        uniform float     time;
        uniform vec2      resolution;
        uniform vec2      mouse;

        #define MAX_ITER 3
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
        void main( void )
        {
            vec2 v_texCoord = gl_FragCoord.xy / resolution;

            vec2 p =  v_texCoord * 8.0 - vec2(20.0);
            vec2 i = p;
            float c = 1.0;
            float inten = .05;


            for (int n = 0; n < MAX_ITER; n++)
            {
                float t = time * (1.0 - (3.0 / float(n+1)));
      t = t / 10.;
      
  

                i = p + vec2(cos(t*mouse.x - i.x) + sin(t + i.y),
                sin(t - i.y-mouse.y) + cos(t + i.x)-mouse.x);
      
                c += 1.0/length(vec2(p.x / (sin(i.x+mouse.y)/inten),
                p.y / (cos(i.y+t)/inten)));
            }
     float poopy = min(mouse.x, mouse.y);
            c /= float(MAX_ITER);
            c = 1.5 - sqrt(c-poopy);

            vec4 texColor = vec4(hsv2rgb(vec3(time*0.05, 0.3, 0.1)), 1);
  

            texColor.rgb *= (1.0 / (1.0 - (c + 0.05))/2.);

            gl_FragColor = texColor;
        }