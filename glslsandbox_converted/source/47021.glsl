#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

int packFloat(inout float f, int off){
    int o = 0;
    
    for (int i = 0; i < 2; i++){
        float mul = 1. / exp2(float(i + off + 1));
        
        if (f >= mul){
            f -= mul;
            
            o += int(exp2(float(i)));
        }
    }
    
    return o;
}

vec4 packFloat4(float f){
    return vec4(
        float(packFloat(f,  0)) / 255.,
        float(packFloat(f,  8)) / 255.,
        float(packFloat(f, 16)) / 255.,
        float(packFloat(f, 24)) / 255.
    );
}

float unpackFloat(int f, int off){
        float o = 0.;
        
        for (int i = 0; i < 8; i++){
            if (bool(mod(floor(float(f) / exp2(float(i))), 2.))){
                o += 1. / exp2(float(i + off + 1));
            }
        }
        
        return o;
    }

    float unpackFloat4(vec4 value){
        return
            unpackFloat(int(value.x * 255.),  0) + 
            unpackFloat(int(value.y * 255.),  8) + 
            unpackFloat(int(value.z * 255.), 16) + 
            unpackFloat(int(value.w * 255.), 24);
    }

void main( void ) {
 vec3 color;
 float y = gl_FragCoord.y / resolution.y;
 
 //our value to compress
 float value = sin(gl_FragCoord.x / 100. + time) / 2. + .5;
 float bit8 = floor(value * 255.) / 255.;
 
 vec4 pack = packFloat4(value);
 vec4 pack8 = floor(pack * 255.) / 255.;
 
 if (y > 0.9){ // output the value as a control
  color = vec3(value);
 }else if (y > 0.8){ // 8 bit precision
  //since everybody here is watching this on a 8bit precision monitor you would
  //not be able to tell the difference. So I am going to render the difference
  //between the source and the destination and multiply that by 1000 so you can
  //see the difference.
  
  color = vec3(abs(bit8 - value) * 1000.); 
 }else if (y > 0.2){
  //output the packed vec4 because it makes a seizure inducing visual.
  color = pack.xyz;
 }else{
  //unpack the value and display the difference multiplied by 1000 (which there is none)
  
  float unpack = unpackFloat4(pack8);
  
  color = vec3(abs(unpack - value) * 1000.);
 }
 
 gl_FragColor = vec4(color, 1);
}