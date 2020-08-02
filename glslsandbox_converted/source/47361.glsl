#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 GetColorFromPhiThetaW( vec3 PhiThetaW )
{
  const float SubDivPhi = 10.0, SubDivTheta = 10.0;
  const vec3 NetHigh = vec3(1, 0, 0);
  const vec3 NetLow = vec3(1, 1, 0);
  const vec3 BackHigh = vec3(0, 0, 0);
  const vec3 BackLow = vec3(0, 0, 1);
  
  if (fract(PhiThetaW.x * SubDivPhi) < 0.1 || fract(PhiThetaW.y * SubDivTheta) < 0.1)
    return 0.5 * (1.0 - PhiThetaW.z) * NetHigh + 0.5 * (PhiThetaW.z + 1.0) * NetLow;
  return 0.5 * (1.0 - PhiThetaW.z) * BackHigh + 0.5 * (PhiThetaW.z + 1.0) * BackLow;
}

vec3 CartesianToRPhiTheta( vec3 Cartesian )
{
  float r = length(Cartesian);
  float Phi = sign(Cartesian.z) * acos(Cartesian.x / length(Cartesian.xz));
  float Theta = acos(-Cartesian.y / r);

  return vec3(r, Phi, Theta);
}

float SphereIntersect( vec3 Loc, vec3 Ray )
{
  float R2 = 1.0;
  float oc2 = dot(Loc, Loc);
  float ok = dot(-Loc, Ray);
  float h2 = R2 - oc2 + ok * ok;
  float Threshold = 1e-4;
  if (R2 - oc2 > Threshold)
    return ok + sqrt(h2);

  if (ok > Threshold && h2 > Threshold)
    return ok - sqrt(h2);
  return -1.0;
}

void main( void )
{
  vec3 WHPos = vec3(0, 0, 0);
  vec3 Loc = vec3(3.0 * cos(time / 3.0), 0, 3.0 * sin(time / 3.0));
  const vec3 Up = vec3(0, 1, 0);
  vec3 Dir = normalize(WHPos - Loc);
  vec3 Right = cross(Up, Dir);
  const float ProjDist = 1.0;

  vec2 ScreenSize = resolution;
  vec2 ProjSize = ScreenSize / min(ScreenSize.x, ScreenSize.y);

  vec2 Pos = 2.0 * gl_FragCoord.xy / ScreenSize - 1.0;
  vec3 Ray = ProjSize.x * Pos.x * Right - ProjSize.y * Pos.y * Up + Dir * ProjDist;
  Ray = normalize(Ray);
  
  vec3 DirToWh = normalize(WHPos - Loc);

  vec2 EquaDir = normalize(vec2(length(Ray / dot(Ray, DirToWh) - DirToWh), 1));
  vec3 EquaRight = normalize(Ray / dot(Ray, DirToWh) - DirToWh);
  vec2 DirRPhi = normalize(vec2(EquaDir.y, EquaDir.x / Loc.x));
  //vec2 DirRPhi = normalize(CartesianToRPhiTheta(Loc + Right * 0.05 * EquaDir.x + Dir * 0.05 * EquaDir.y).xy - CartesianToRPhiTheta(Loc - Right * 0.05 * EquaDir.x - Dir * 0.05 * EquaDir.y).xy);
  float Ksi = asin(DirRPhi.y / DirRPhi.x);
  vec3 LocS = CartesianToRPhiTheta(Loc);

  const float b0 = 1.0;
  const float b02 = 1.0;
  float ro = LocS.x - b0;
  float d1 = asin(sqrt(b02 / (b02 + ro * ro)));
  float h = sin(Ksi) / sin(d1);
  if (Pos.x > 0.0)
  {
    gl_FragColor = vec4(vec3(h), 1);
    return;
  }
  
  //float dPhi = h * I;


  float t = SphereIntersect(Loc, Ray);
  if (t > 0.0)
  {
    vec3 LPhiTheta = CartesianToRPhiTheta(Loc + t * Ray);
    gl_FragColor = vec4(GetColorFromPhiThetaW(vec3(LPhiTheta.yz, 1)), 1);
    return;
  }

  gl_FragColor = vec4(GetColorFromPhiThetaW(vec3(CartesianToRPhiTheta(Ray).yz, -1)), 1);
  return;
}
