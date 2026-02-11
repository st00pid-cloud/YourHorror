shader_type canvas_item;

// Hint: Set the ColorRect color to white with 0 alpha to see through it
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float bulge_amount : hint_range(0.0, 1.0) = 0.2;
uniform float aberration_amount : hint_range(0.0, 0.1) = 0.005;
uniform float scanline_count : hint_range(0.0, 1000.0) = 300.0;
uniform float noise_amount : hint_range(0.0, 1.0) = 0.05;
uniform float noise_speed : hint_range(0.0, 10.0) = 5.0;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Function to warp UVs into a circle/bulge
vec2 distort(vec2 uv) {
    vec2 centered = uv - 0.5;
    float dist = dot(centered, centered);
    // The distortion formula
    return uv + centered * dist * bulge_amount;
}

void fragment() {
    // 1. Apply the Bulge Distortion
    vec2 distorted_uv = distort(SCREEN_UV);
    
    // 2. Chromatic Aberration (Offsetting RGB channels)
    float r = texture(screen_texture, distorted_uv + vec2(aberration_amount, 0.0)).r;
    float g = texture(screen_texture, distorted_uv).g;
    float b = texture(screen_texture, distorted_uv - vec2(aberration_amount, 0.0)).b;
    
    vec3 scene_color = vec3(r, g, b);

    // 3. Scanlines
    float scanline = sin(distorted_uv.y * scanline_count) * 0.1;
    scene_color -= scanline;

    // 4. Cut off the edges (Vignette/Masking)
    // Since we distorted the UVs, the edges might look weird. 
    // This creates a clean black border.
    if (distorted_uv.x < 0.0 || distorted_uv.x > 1.0 || distorted_uv.y < 0.0 || distorted_uv.y > 1.0) {
        scene_color = vec3(0.0);
    }

    COLOR = vec4(scene_color, 1.0);
	
// Apply Noise Grain
    float noise = random(distorted_uv + fract(TIME * noise_speed));
    scene_color += (noise - 0.5) * noise_amount;

    // Mask the edges
    if (distorted_uv.x < 0.0 || distorted_uv.x > 1.0 || distorted_uv.y < 0.0 || distorted_uv.y > 1.0) {
        scene_color = vec3(0.0);
    }

    COLOR = vec4(scene_color, 1.0);
}