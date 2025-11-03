extends Node

@export var initial_position: Vector2

@export_category("Nodes")
@export var door: Sprite2D
@export var visitors: Array[PackedScene]

signal visit(count)

var timeout
var current_visitor
var tween: Tween
var count = 2
var last = count
var visitor_count = 0
var mean: float
var length: int
const deviation = 0.25

func scale() -> float:
	return max(3-(0.2*visitor_count), 1.5)

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
	tween.tween_property(current_visitor, "position", door.position, 0.5*scale())
	await get_tree().create_timer(0.5*scale()-0.2).timeout
	door.set_visible(false)
	timeout = false


func button_pressed(candy: String):
	if timeout:
		return

	if current_visitor.desired_candy == candy:
		print("good")
	else:
		print("bad")
	timeout = true
	door.set_visible(true)
	remove_child(current_visitor)
	visitor_count += 1
	visit.emit(visitor_count)
	mean = scale()
	length = clamp(randfn(mean, deviation), mean - 4 * deviation, mean + 4 * deviation)
	await get_tree().create_timer(length).timeout
	spawn_visitor()

func _ready() -> void:
	spawn_visitor()
