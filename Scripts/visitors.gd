extends Node

@export var door: Sprite2D
@export var mean: float
@export var deviation: float
@onready var visitors = [
	preload("res://Scenes/Presets/basajaun.tscn"),
	#preload("res://Scenes/Presets/blemmyes.tscn"),
	#preload("res://Scenes/Presets/cyclops.tscn"),
	preload("res://Scenes/Presets/deep.tscn"),
	preload("res://Scenes/Presets/ogre.tscn"),
	#preload("res://Scenes/Presets/satyr.tscn")
]
@export var move_speed: float
@export var initial_position: Vector2

var timeout
var current_visitor
var tween: Tween
var count = 2
var last = count

func get_random() -> int:
	var rand = randi_range(0, count-1)
	if rand >= last:
		rand += 1
	last = rand
	return rand

func spawn_visitor():
	current_visitor = visitors[get_random()].instantiate()
	current_visitor.position = initial_position
	current_visitor.z_index = -75
	add_child(current_visitor)
	tween = create_tween()
	tween.tween_property(current_visitor, "position", door.position, move_speed)
	await get_tree().create_timer(move_speed-0.2).timeout
	door.set_visible(false)
	timeout = false


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
	var length = clamp(randfn(mean, deviation), mean - 4 * deviation, mean + 4 * deviation)
	await get_tree().create_timer(length).timeout
	spawn_visitor()

func _ready() -> void:
	spawn_visitor()
