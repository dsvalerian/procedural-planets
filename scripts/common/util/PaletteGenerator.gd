var rng

func init(seed_value):
	rng = RandomNumberGenerator.new()
	rng.seed = seed_value

func generate_random_colors(num_colors):
	if num_colors < 1:
		return []
	
	var a = Vector3(0.5, 0.5, 0.5)
	var b = Vector3(0.25, 0.25, 0.25)
	var c = Vector3( \
		rng.randf_range(0.5, 1.5), \
		rng.randf_range(0.5, 1.5), \
		rng.randf_range(0.5, 1.5)) * 0.9
	var d = Vector3( \
		rng.randf_range(0.0, 1.0), \
		rng.randf_range(0.0, 1.0), \
		rng.randf_range(0.0, 1.0)) * rng.randf_range(1.0, 3.0)
	
	var t = 0.0
	var colors = []
	for i in range(num_colors):
		var red = palette_helper(a.x, b.x, c.x, d.x, t)
		var green = palette_helper(a.y, b.y, c.y, d.x, t)
		var blue = palette_helper(a.z, b.z, c.z, d.x, t)
		colors.append(Vector3(red, green, blue));
		t += 1.0 / num_colors
		
	return colors
	
func palette_helper(a, b, c, d, t):
	return a + b * cos(6.28318 * (c * t + d))
	

func gradient_texture_from_colors(colors):
	var gradient = Gradient.new()
	var gradient_texture = GradientTexture.new()
	var num_colors = colors.size()
	
	if (num_colors < 1):
		return gradient_texture
	
	var offset_gap = 1.0 / float(num_colors)
	
	var offset = 0.0
	for i in range(num_colors):
		gradient.add_point(i * offset_gap, Color(colors[i].x, colors[i].y, colors[i].z))
	gradient_texture.set_gradient(gradient)
	return gradient_texture

func generate_random_gradient_texture(num_colors):
	return gradient_texture_from_colors(generate_random_colors(num_colors))
