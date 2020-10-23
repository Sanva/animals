#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_mouse;

in vec4 fColor;

out vec4 fragColor;

void main() {

	fragColor = vec4(1, u_mouse, 1);

}