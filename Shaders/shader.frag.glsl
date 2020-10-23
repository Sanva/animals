#version 450

in vec4 fColor;
in vec2 fUV;

uniform sampler2D myTextureSampler;

out vec4 FragColor;

void main() {

  // float avg = (fColor.r + fColor.g + fColor.b) / 3;
  // FragColor = vec4(avg, avg, avg, 0.05);

	// FragColor = fColor * texture(myTextureSampler, fUV);

  vec4 textureColor = fColor * texture(myTextureSampler, fUV);
	// textureColor.rgb *= fColor.a;
	// textureColor.a = fColor.a;

	FragColor = textureColor;

    // FragColor = fColor;

}