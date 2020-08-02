/*{
  \"pixelRatio\": 1,
  \"vertexCount\": 3000,
  \"vertexMode\": \"POINTS\",
}*/
precision mediump float;
uniform float vertexId;
uniform float vertexCount;
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
varying vec4 v_color;

void main() {
  float t = time * .5;
  float i = vertexId + sin(vertexId) * 2.;

  vec4 pos = vec4(
    sin(t + vertexId + i * 8.) * cos(t * .42 + i),
    sin(t + vertexId + i * 4.2) * sin(t * .42 + i),
    cos(t + vertexId - i) * cos(t * .21 + i),
    cos(t) * sin(t + vertexId)
  );


  vec4 v_color = vec4(
    fract(pos.x *.4 + mouse.x * 4.),
    fract(pos.y * .5 + mouse.y),
    fract(pos.z * .4 ),
    1
  );
}