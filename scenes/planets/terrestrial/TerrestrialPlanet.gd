extends 'res://scenes/planets/Planet.gd'

onready var TerrestrialPlanetShader = preload('res://shaders/planets/terrestrial/terrestrial_planet.shader')
onready var PaletteGenerator = preload('res://scripts/common/util/PaletteGenerator.gd')
onready var ColorUtil = preload('res://scripts/common/util/ColorUtil.gd')

var pg
var color_util

func init(seed_value):
	rng = RandomNumberGenerator.new()
	pg = PaletteGenerator.new()
	color_util = ColorUtil.new()
	
	set_seed(seed_value)
	pg.init(seed_value)
	set_shader(TerrestrialPlanetShader)
	randomize_planet()
	
func set_colors(colors):
	self.colors = colors
	PlanetColorRect.material.set_shader_param('colors', pg.gradient_texture_from_colors(colors))

func randomize_planet():
	set_planet_size(rng.randf_range(planet_size_range.x, planet_size_range.y))
	set_size_on_screen(planet_size)
	set_num_pixels(size_on_screen / 3.0)
	set_rotation(rng.randf_range(planet_rotation_range.x, planet_rotation_range.y))
	
	set_light_origin(Vector2(rng.randf_range(light_origin_range.x, light_origin_range.y), \
			rng.randf_range(light_origin_range.x, light_origin_range.y)))
		
	set_light_border(rng.randf_range(light_border_range.x, light_border_range.y))
	set_spin_speed(rng.randf_range(spin_speed_range.x, spin_speed_range.y))
	
	set_colors(pg.generate_random_colors(num_colors))
	
	var darkest_color = color_util.get_darkest_color(self.colors)
	var shadow_color = Color(darkest_color.x, darkest_color.y, darkest_color.z).darkened(0.5)
	set_shadow_color(Plane(shadow_color.r, shadow_color.g, shadow_color.b, 1.0))
