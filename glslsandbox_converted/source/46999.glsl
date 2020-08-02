#ifdef GL_ES
precision mediump float;
#endif
//lit

// Half-a-Q*bert, by @ko_si_nus
// This is a cludge, but by god it works.

// - Q*bert will follow the mouse.
// - Jumping off the board will simply move you back to the top.
// - There's no win condition, but you can toggle each tile twice.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

const float PI = 3.141592653589793;
const float HALFPI = PI / 2.0;
const float TAN30 = 0.5773502691896256;
const float COS30 = 0.8660254037844387;
const float SIN30 = 0.5;
const float XPERIOD = 2.0 * COS30;
const float YPERIOD = 2.0 + 2.0 * SIN30;
const float HALFXPERIOD = XPERIOD / 2.0;
const float HALFYPERIOD = YPERIOD / 2.0;
const float SCALE = 14.0;
const vec4 LSHADE = vec4(0.2, 0.2, 0.2, 1.0);
const vec4 RSHADE = vec4(0.3, 0.3, 0.3, 1.0);

vec4 stateToValues(float x) {
 vec4 color = texture2D(backbuffer, vec2(x + 0.5, 0.5) / resolution.xy);
 return floor(color * 255.0 + 0.5);
}

vec4 valuesToState(float r, float g, float b) {
 return vec4(r / 255.0, g / 255.0, b / 255.0, 1.0);
}

vec3 idxToCube(float idx) {
 vec3 cube = vec3(0.0, 0.0, idx);
 cube.x = mod(cube.z, 10.0) - 2.0;
 cube.y = floor(cube.z / 10.0) - 1.0;
 return cube;
}

float cubeToIdx(vec3 cube) {
 return (cube.y + 1.0) * 10.0 + cube.x + 2.0;
}

vec2 cubeToPos(vec3 cube) {
 return vec2(
  (cube.x + cube.y / 2.0) * XPERIOD,
  (cube.y + 2.0) * HALFYPERIOD);
}

void main(void) {
 vec4 color;
 
 // r = currentFlank, g = playerFrom, b = playerTo
 vec4 state = stateToValues(0.0);
 
 float tick = time / 0.8;
 float flank = mod(floor(tick), 30.0);
 float tickOff = flank != state.r ? 1.0 : fract(tick);
 
 float scale = resolution.y / SCALE;
 vec2 padding = vec2((resolution.x / scale - 6.0 * XPERIOD) / 2.0, 0.0);
 vec2 position = gl_FragCoord.xy / scale - padding;
 
 vec3 fromCube = idxToCube(state.g);
 vec3 toCube = idxToCube(state.b);
 vec2 fromPos = cubeToPos(fromCube);
 vec2 toPos = cubeToPos(toCube);
 vec2 playerPos = mix(fromPos, toPos, tickOff);
 if (tickOff < 0.4) {
  playerPos.y += sqrt(tickOff / 0.4);
 }
 else {
  playerPos.y += sqrt(1.0 - (tickOff - 0.4) / 0.6);
 }
 
 if (gl_FragCoord.y < 1.0) {
  if (gl_FragCoord.x < 1.0) {
   if (state.r != flank) {
    vec2 mouseDelta = (mouse * resolution / scale - padding) - toPos;
    float angle = atan(mouseDelta.y, mouseDelta.x);
    if (toCube.y < 0.0 || toCube.y >= 7.0 || toCube.x < 0.0 || toCube.x >= 7.0 - toCube.y) {
     toCube.x = 0.0;
     toCube.y = 6.0;
    }
    else if (angle < -HALFPI) {
     toCube.y -= 1.0;
    }
    else if (angle < 0.0) {
     toCube.y -= 1.0;
     toCube.x += 1.0;
    }
    else if (angle < HALFPI) {
     toCube.y += 1.0;
    }
    else {
     toCube.y += 1.0;
     toCube.x -= 1.0;
    }
    color = valuesToState(flank, state.b, cubeToIdx(toCube));
   }
   else {
    color = valuesToState(flank, state.g, state.b);
   }
   //color = valuesToState(flank, 25.0, 25.0);
  }
  
  else {
   vec3 cube = idxToCube(floor(gl_FragCoord.x - 1.0));
   float steps = stateToValues(1.0 + cube.z).r;
   
   if (cube.y < 0.0 || cube.y >= 7.0 || cube.x < 0.0 || cube.x >= 7.0 - cube.y)
    steps = 0.0;
   else if (state.r != flank && state.b == cube.z)
    steps += 1.0;
   color = valuesToState(clamp(steps, 0.0, 2.0), 0.0, 0.0);
  }
 }
 
 else if (distance(playerPos, position) < 0.2) {
  color = vec4(1.0, 1.0, 1.0, 1.0);
 }
 
 else {
  float x;
  float y = mod(position.y, YPERIOD);
  float upper = step(HALFYPERIOD, y);
  if (upper == 0.0) {
   x = mod(position.x, XPERIOD);
  }
  else {
   x = mod(position.x + HALFXPERIOD, XPERIOD);
   y -= HALFYPERIOD;
  }
  
  vec3 cube = vec3(
   floor(position.x / XPERIOD),
   floor(position.y / HALFYPERIOD) - 1.0,
   0.0);

  float opp;
  if (x < COS30) {
   cube.x += upper;
   color = LSHADE;
   opp = TAN30 * (COS30 - x);
   if (y < opp) {
    cube.x -= upper;
    cube.y -= 1.0;
   }
  }
  else {
   color = RSHADE;
   opp = TAN30 * (x - COS30);
   if (y < opp) {
    cube.x += 1.0-upper;
    cube.y -= 1.0;
   }
  }
  
  cube.x -= floor(cube.y / 2.0);
  cube.z = cubeToIdx(cube);
  
  if (cube.y < 0.0 || cube.y >= 7.0 || cube.x < 0.0 || cube.x >= 7.0 - cube.y) {
   color = vec4(0.0, 0.0, 0.0, 0.0);
  }
  else if (y < opp || opp < y-1.0) {
   float steps = stateToValues(1.0 + cube.z).r;
   if (steps == 2.0)
    color = vec4(0.0, 0.6, 0.0, 1.0);
   else if (steps == 1.0)
    color = vec4(1.0, 1.0, 0.0, 1.0);
   else
    color = vec4(0.4, 0.4, 0.7, 1.0);
  }
 }
 
 gl_FragColor = color;
}