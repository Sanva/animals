#version 450

in vec3 position;
in vec4 color;
in vec2 uv;

uniform mat4 MVP;

out vec4 fColor;
out vec2 fUV;

void main() {

  fColor = color;
  fUV = uv;

	gl_Position = MVP * vec4(position, 1.0);

}