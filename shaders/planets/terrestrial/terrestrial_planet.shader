shader_type canvas_item;
render_mode blend_mix;

uniform int seed;

uniform float num_pixels;
uniform float spin_speed : hint_range(0.0, 1.0);
uniform float rotation : hint_range(-6.28, 6.28, .01);

uniform sampler2D colors;
uniform vec4 shadow_color;

uniform vec2 light_origin;
uniform float light_border;

const int NUM_COLORS = 5;
const float NOISE_SIZE = 5.0;
const int NOISE_OCTAVES = 5;

// Generates a random number based on a coordinate and the seed
float rand(vec2 coord) {
	float true_seed = (float(seed % 100000) / 100000.0) * 10.0 + 1.0;
	
	coord = mod(coord, vec2(2.0, 1.0) * round(NOISE_SIZE));
	return fract(sin(dot(coord.xy, vec2(12.9898, 78.233))) * 43758.5453 * true_seed);
}

// Generates a noise value at a coordinate
float noise(vec2 coord) {
	vec2 vec_floor = floor(coord);
	vec2 vec_fract = fract(coord);
	
	float a = rand(vec_floor);
	float b = rand(vec_floor + vec2(1.0, 0.0));
	float c = rand(vec_floor + vec2(0.0, 1.0));
	float d = rand(vec_floor + vec2(1.0, 1.0));
	
	vec2 cubic = vec_fract * vec_fract * (3.0 - 2.0 * vec_fract);
	
	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

// Generates fractal brownian motion value based on a coordinate
float fbm(vec2 coord) {
	float value = 0.0;
	float scale = 0.5;
	
	for (int i = 0; i < NOISE_OCTAVES; i++) {
		value += noise(coord) * scale;
		coord *= 2.0;
		scale *= 0.5;
	}
	
	return value;
}

vec2 spherify(vec2 uv) {
	vec2 centered = uv * 2.0 - 1.0;
	float z = sqrt(1.0 - dot(centered.xy, centered.xy));
	vec2 sphere = centered / (z + 1.0);
	return sphere * 0.5 + 0.5;
}

vec2 rotate(vec2 coord, float angle){
	coord -= 0.5;
	coord *= mat2(vec2(cos(angle), -sin(angle)),vec2(sin(angle), cos(angle)));
	return coord + 0.5;
}

// Per pixel shader
void fragment() {
	// Pixelizing the image
	vec2 pixel_uv = floor(UV * num_pixels) / num_pixels;
	
	// Spherifying the uv (making it look 3d instead of a flat 2d image)
	vec2 sphere_uv = spherify(pixel_uv);
	
	// Making the image a circle
	float dist_to_center = distance(sphere_uv, vec2(0.5));
	float in_circle = step(dist_to_center, 0.5);
	
	// Rotating the circle
	vec2 uv = rotate(sphere_uv, rotation);
	
	// Filling the circle with noise/fractal brownian motion
	float noise_value = fbm(uv * NOISE_SIZE + TIME * vec2(spin_speed, 0.0));
	
	// Sampling colors from the gradient texture
	vec4 color1 = texture(colors, vec2(0.0, 0.0));
	vec4 color2 = texture(colors, vec2(1.0 / float(NUM_COLORS), 0.0));
	vec4 color3 = texture(colors, vec2((1.0 / float(NUM_COLORS)) * 2.0, 0.0));
	vec4 color4 = texture(colors, vec2((1.0 / float(NUM_COLORS)) * 3.0, 0.0));
	vec4 color5 = texture(colors, vec2((1.0 / float(NUM_COLORS)) * 4.0, 0.0));
	
	// Determining how colors are dispersed across the noise values
	vec4 color = color1;
	if (noise_value < 0.65) {
		color = color2;
	}
	if (noise_value < 0.55) {
		color = color3;
	}
	if (noise_value < 0.45) {
		color = color4;
	}
	if (noise_value < 0.35) {
		color = color5;
	}
	
	// Mixing shadow color into the regular colors
	float dist_to_light = distance(sphere_uv, light_origin);
	if (dist_to_light > light_border) {
		float dist_to_border = dist_to_light - light_border;
		float mix_amount = floor(dist_to_border * 10.0) / 5.0;
		color = mix(color, shadow_color, 0.5);
	}
	
	// Finally, assigning the color
	COLOR = vec4(color.rgb, in_circle);
}