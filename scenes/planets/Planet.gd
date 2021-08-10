extends Node2D

onready var PlanetColorRect = $ColorRect;
var rng

var light_origin
var light_border
var planet_size
var planet_rotation
var spin_speed
var colors
var shadow_color
var size_on_screen

export(int, -1000000000, 1000000000) var seed_value = 0
export(int, 10, 1000) var num_pixels
export(int, 3, 10) var num_colors = 5
export(Vector2) var planet_size_range
export(Vector2) var planet_rotation_range
export(Vector2) var light_origin_range
export(Vector2) var light_border_range
export(Vector2) var spin_speed_range

func init(seed_value):
	set_seed(seed_value)

func randomize_planet():
	pass

func set_seed(seed_value):
	self.seed_value = seed_value
	PlanetColorRect.material.set_shader_param('seed', seed_value)
	rng.seed = seed_value;

func set_shader(shader):
	PlanetColorRect.material = PlanetColorRect.material.duplicate()
	PlanetColorRect.material.shader = shader
	
func set_size_on_screen(size):
	self.size_on_screen = size
	
	# Change size of the colorrect
	PlanetColorRect.rect_size = Vector2(size, size)
	
func set_num_pixels(num_pixels):
	self.num_pixels = num_pixels
	PlanetColorRect.material.set_shader_param('num_pixels', num_pixels)

func set_planet_size(size):
	self.planet_size = size
	
func set_light_origin(origin):
	self.light_origin = origin
	PlanetColorRect.material.set_shader_param('light_origin', origin)
	
func set_light_border(border):
	self.light_border = border
	PlanetColorRect.material.set_shader_param('light_border', border)

func set_rotation(planet_rotation):
	self.planet_rotation = planet_rotation
	PlanetColorRect.material.set_shader_param('rotation', planet_rotation)

func set_spin_speed(speed):
	self.spin_speed = speed
	PlanetColorRect.material.set_shader_param('spin_speed', speed)

func set_colors(colors):
	self.colors = colors
	PlanetColorRect.material.set_shader_param('colors', colors)

func set_shadow_color(color):
	self.shadow_color = color
	PlanetColorRect.material.set_shader_param('shadow_color', color)
