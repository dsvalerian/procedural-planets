extends Node2D

onready var TerrestrialPlanet = preload('res://scenes/planets/terrestrial/TerrestrialPlanet.tscn')
onready var rng = RandomNumberGenerator.new()

export(float, -200000, 200000) var seed_value

var planet_child
var planet_child_exists = false

func _ready():
	rng.seed = seed_value
	
func delete_planet():
	if (planet_child_exists):
		planet_child.queue_free()
		planet_child_exists = false

func create_new_planet():
	if (!planet_child_exists):
		planet_child = TerrestrialPlanet.instance()
		add_child(planet_child)
		planet_child.init(rng.randi_range(-2000000, 2000000))
		
		planet_child_exists = true

func _process(delta):
	if Input.is_action_just_pressed('ui_accept'):
		delete_planet()
		create_new_planet()
