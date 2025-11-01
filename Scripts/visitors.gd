extends Node
@export var door:Sprite2D
@onready var visitors = [preload("res://Scenes/Presets/Visitor1.tscn"),
preload("res://Scenes/Presets/Visitor2.tscn")]
@export var cooldowntime:float
var timeout
var current_visitor
func spawn_visitor():
	door.set_visible(false)
	current_visitor = visitors[randi_range(0,1)].instantiate()
	current_visitor.position = door.position
	current_visitor.set_z_index(-1)
	add_child(current_visitor)
func button_pressed(trick:bool):
	if timeout:
		return
	if current_visitor.trick == trick:
		print("good")
	else:
		print("bad")
	door.set_visible(true)
	remove_child(current_visitor)
	timeout = true
	await get_tree().create_timer(cooldowntime).timeout 
	timeout = false
	spawn_visitor()
func _ready() -> void:
	spawn_visitor()
