shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float scanline_count : hint_range(0, 1080) = 300.0;
uniform float glitch_intensity : hint_range(0.0, 1.0) = 0.0;
uniform float green_tint_strength : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    
    // Apply horizontal glitch displacement
    if (glitch_intensity > 0.0) {
        float noise = fract(sin(dot(uv.yy, vec2(12.9898, 78.233))) * 43758.5453);
        uv.x += noise * (glitch_intensity * 0.05);
    }
    
    vec4 color = texture(SCREEN_TEXTURE, uv);
    
    // Create Scanlines
    float s = sin(uv.y * scanline_count * PI * 2.0);
    s = (s * 0.5 + 0.5) * 0.9 + 0.1;
    
    // Diagnostic Green Color Grading
    vec3 green_output = vec3(color.r * 0.1, color.g * 1.2, color.b * 0.1);
    vec3 final_rgb = mix(color.rgb, green_output, green_tint_strength);
    
    COLOR = vec4(final_rgb * s, color.a);
}