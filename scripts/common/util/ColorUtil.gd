# Expects an array of Vector3
# Returns a Vector3
func get_darkest_color(colors):
	var darkest_color = Color(1.0, 1.0, 1.0)
	
	for i in range(colors.size()):
		var color = Color(colors[i].x, colors[i].y, colors[i].z)
		if color.v < darkest_color.v:
			darkest_color = color
			
	return Vector3(darkest_color.r, darkest_color.g, darkest_color.b)
