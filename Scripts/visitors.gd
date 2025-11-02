extends Node

@export var door: Sprite2D
@export var mean: float
@export var deviation: float
@onready var visitors = [
	preload("res://Scenes/Presets/basajaun.tscn"),
	preload("res://Scenes/Presets/blemmyes.tscn"),
	preload("res://Scenes/Presets/cyclops.tscn"),
	preload("res://Scenes/Presets/deep.tscn"),
	preload("res://Scenes/Presets/ogre.tscn"),
	preload("res://Scenes/Presets/satyr.tscn")
]

var timeout
var current_visitor

func spawn_visitor():
	door.set_visible(false)
	current_visitor = visitors.pick_random().instantiate()
	current_visitor.position = door.position
	add_child(current_visitor)

func button_pressed(candy: String):
	if timeout:
		return

	if current_visitor.desired_candy == candy:
		print("good")
	else:
		print("bad")

	door.set_visible(true)
	remove_child(current_visitor)
	timeout = true
	var length = clamp(randfn(mean, deviation), mean - 3 * deviation, mean + 3 * deviation)
	await get_tree().create_timer(length).timeout
	timeout = false
	spawn_visitor()

func _ready() -> void:
	spawn_visitor()
