extends Node

@export var door: Sprite2D
@onready var visitors = [preload("res://Scenes/Assets/Visitor1.tscn"), preload("res://Scenes/Assets/Visitor2.tscn")]
@export var mean: float
@export var deviation: float

var timeout
var current_visitor

func spawn_visitor():
	door.set_visible(false)
	current_visitor = visitors[randi_range(0, 1)].instantiate()
	current_visitor.position = door.position
	add_child(current_visitor)

func button_pressed(trick: bool):
	if timeout:
		return

	if current_visitor.trick == trick:
		print("good")
	else:
		print("bad")

	door.set_visible(true)
	remove_child(current_visitor)
	timeout = true
	var length = clamp(randfn(mean, deviation), mean - 3*deviation, mean + 3*deviation)
	await get_tree().create_timer(length).timeout
	timeout = false
	spawn_visitor()

func _ready() -> void:
	spawn_visitor()
