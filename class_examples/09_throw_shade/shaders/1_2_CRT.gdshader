shader_type canvas_item;

// Screen texture uniform: Provides the ColorRect as input for the shader.
uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;

uniform float depth = 0.03;
uniform int line_thickness = 7;
uniform float bulge_amount = 0.03;
uniform float step_softness = 0.5;

void fragment() {
    // Scale everything relative to the canvas layer
    vec2 uv = SCREEN_UV;
    vec2 pixel_size = vec2(1.0) / (vec2(1.0) / SCREEN_PIXEL_SIZE);

    // Center coordinates on the shader area
    vec2 center_offset = UV - vec2(0.5);
    float dist = length(center_offset);

    // Apply barrel distortion
    float bulge = 1.0 + (bulge_amount * dist * dist);
    vec2 bulged_uv = SCREEN_UV + (center_offset * bulge - center_offset);

    // Sample the screen texture at the bulged position
    vec3 color = texture(screen_texture, bulged_uv).rgb;

    // Scale lines to canvas pixels
    float line_pos = VERTEX.x / pixel_size.x;
    float step_value = float(int(line_pos) % (2 * line_thickness)) / float(line_thickness);
    float soft_step = smoothstep(0.0, step_softness, step_value) -
                      smoothstep(1.0 - step_softness, 1.0, step_value);

    color = color * (1.0 - (depth * soft_step));

    // Scale scanlines to canvas size
    float scan_line = sin(bulged_uv.y / SCREEN_PIXEL_SIZE.y * 480.0) * 0.005;
    color += vec3(scan_line);

    float vignette = 1.0 - dist * 0.5;
    COLOR.rgb = color * vignette;
}