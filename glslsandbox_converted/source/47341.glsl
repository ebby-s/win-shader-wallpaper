#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float distance_from_sphere(in vec3 p, in vec3 c, float r)
{
    return length(p - c) - r;
}

vec3 ray_march(in vec3 ro, in vec3 rd, vec3 mouse1, vec3 disk)
{
    float total_distance_traveled = 0.0;
    const int NUMBER_OF_STEPS = 32;
    const float MINIMUM_HIT_DISTANCE = 0.001;
    const float MAXIMUM_TRACE_DISTANCE = 1000.0;

    for (int i = 0; i < NUMBER_OF_STEPS; ++i)
    {
        // Calculate our current position along the ray
        vec3 current_position = ro + total_distance_traveled * rd;

        // We wrote this function earlier in the tutorial -
        // assume that the sphere is centered at the origin
        // and has unit radius
        float distance_to_closest = distance_from_sphere(current_position, disk, 1.0);

        if (distance_to_closest < MINIMUM_HIT_DISTANCE) // hit
        {
            // We hit something! Return red for now
     float _f = (dot((current_position-disk), (current_position-disk) + mouse1-disk))*0.5;
            return vec3(_f*0.6, _f*0.6, _f*0.25);
        }

        if (total_distance_traveled > MAXIMUM_TRACE_DISTANCE) // miss
        {
            break;
        }

        // accumulate the distance traveled thus far
        total_distance_traveled += distance_to_closest;
    }
 return vec3(0.0);
}
//X
mat3 rotCam(float angle) {
 return mat3(1.0, 0.0, 0.0,
      0.0, cos(angle), -sin(angle),
      0.0, sin(angle), cos(angle));
}
//Y 
mat3 rotCamY(float angle) {
 return mat3(cos(angle), 0.0, sin(angle),
      0.0, 1., 0.0,
      -sin(angle), 0.0, cos(angle));
}
void main() {

 vec2 uv = ( gl_FragCoord.xy / resolution.xy ) *2.0 -1.0;
 uv.x *= resolution.x/resolution.y;
 vec2 mouse1 = mouse *2.0 -1.0;

 
 vec3 sun = vec3 (-0, 3., 3.);
 vec3 camera_position = vec3(0,  0.0, -8.);
 //vec3 camera_position = vec3(3.*sin(1.+time),  0.0, -7. + 3. * cos(1.+time));

 
 //camera_position += vec3(0.0, 0.0, 2.0); 
 //camera_position *= rotCam(1.+time);
 //camera_position -= vec3(0.0, 0.0, 2.0); 
 
 //camera_position -= vec3(0.0, 0.0, fract(time));
     vec3 ro = camera_position;
     vec3 rd = vec3(uv, 1.);

 sun *= rotCamY(1.+time);
 
 vec3 shaded_color = vec3(0.0);
     shaded_color = ray_march(ro, rd, sun, vec3(0.0));
 shaded_color += ray_march(ro, rd, sun, vec3 (3.0, 0.0, -.0));
 shaded_color += ray_march(ro, rd, sun, sun); 

 gl_FragColor = vec4(shaded_color, 1.0);

}