shader_type canvas_item;
// Screen texture uniform: Provides the ColorRect as input for the shader.
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float blur_amount: hint_range(0.0, 10.0) = 2.0;
uniform vec4 blue_tint: source_color = vec4(0.9, 0.95, 1.0, 1.0);

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 color = vec4(0.0);

    // Sample multiple points around the current pixel
    float blur_radius = blur_amount / 1000.0;

    // Center pixel (weighted more heavily)
    color += texture(SCREEN_TEXTURE, uv) * 0.4;

    // Surrounding pixels
    color += texture(SCREEN_TEXTURE, uv + vec2(blur_radius, 0.0)) * 0.1;
    color += texture(SCREEN_TEXTURE, uv + vec2(-blur_radius, 0.0)) * 0.1;
    color += texture(SCREEN_TEXTURE, uv + vec2(0.0, blur_radius)) * 0.1;
    color += texture(SCREEN_TEXTURE, uv + vec2(0.0, -blur_radius)) * 0.1;

    // Diagonal pixels
    color += texture(SCREEN_TEXTURE, uv + vec2(blur_radius, blur_radius)) * 0.05;
    color += texture(SCREEN_TEXTURE, uv + vec2(-blur_radius, blur_radius)) * 0.05;
    color += texture(SCREEN_TEXTURE, uv + vec2(blur_radius, -blur_radius)) * 0.05;
    color += texture(SCREEN_TEXTURE, uv + vec2(-blur_radius, -blur_radius)) * 0.05;

    // Apply the blue tint
    COLOR = color * blue_tint;
}