shader_type canvas_item;

// Screen texture uniform: Provides the ColorRect as input for the shader.
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float offset_red: hint_range(-0.1, 0.1) = 0.005;
uniform float offset_green: hint_range(-0.1, 0.1) = -0.001;
uniform float offset_blue: hint_range(-0.1, 0.1) = -0.005;
uniform vec2 direction = vec2(1.0, 0.2); // Allows for diagonal offset

void fragment() {
    vec2 normalized_direction = normalize(direction);

    // Sample each color channel at different offsets
    float red = texture(SCREEN_TEXTURE, SCREEN_UV + (normalized_direction * offset_red)).r;
    float green = texture(SCREEN_TEXTURE, SCREEN_UV + (normalized_direction * offset_green)).g;
    float blue = texture(SCREEN_TEXTURE, SCREEN_UV + (normalized_direction * offset_blue)).b;

    // Combine the channels
    COLOR = vec4(red, green, blue, 1.0);
}