shader_type canvas_item;

// Screen texture uniform: Provides the ColorRect as input for the shader.
// The `hint_screen_texture` makes it compatible with the current screen rendering.
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Threshold uniform: Determines the brightness threshold for processing.
// If a pixel's brightness (average of RGB values) is below this threshold, it will be darkened.
// If it's above, it will be brightened.
uniform float threshold: hint_range(0.0,1.0) = 0.5;

// Delta uniform: Controls the amount of brightness adjustment.
// Darkening or brightening will add or subtract this value to the pixel's RGB channels.
uniform float delta: hint_range(0.0,1.0) = 0.2;

void fragment() {
    // Retrieve the current pixel's color from the screen texture using its UV coordinates.
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    // Calculate the average brightness of the current pixel by averaging its red, green, and blue channels.
    float avg = (screen_color.r + screen_color.g + screen_color.b) / 3.0;

    // Compare the average brightness to the threshold.
    if (avg < threshold) {
        // If the brightness is below the threshold, darken the pixel by subtracting delta.
        COLOR.rgb = vec3(screen_color.r - delta, screen_color.r - delta, screen_color.r - delta);
    } else {
        // If the brightness is above the threshold, brighten the pixel by adding delta.
        COLOR.rgb = vec3(screen_color.r + delta, screen_color.r + delta, screen_color.r + delta);
    }
}