extends Node

@export var initial_position: Vector2

@export_category("Visitors")
@onready var door = $"../Door"
@export var humans: Array[PackedScene]
@export var monsters: Array[PackedScene]
@export var hidden_monsters: Array[PackedScene]


signal visit(count: int)
signal door_state(state: bool)

var timeout: bool
var current_visitor
var tween: Tween
var count = 2
var last = count
var visitor_count = 0
var mean: float
var length: int
const deviation = 0.25
var score = 0
var tim: Timer

func scale() -> float:
	return max(4-(0.2*visitor_count), 2)

func get_random() -> int:
	var rand = randi_range(0, count-1)
	if rand >= last:
		rand += 1
	last = rand
	return rand

func spawn_visitor():
	if visitor_count < 3:
		current_visitor = humans[get_random()].instantiate()
	elif visitor_count < 6:
		current_visitor = monsters[get_random()].instantiate()
	else:
		current_visitor = hidden_monsters[get_random()].instantiate()
		
	current_visitor.position = initial_position
	current_visitor.z_index = -75
	add_child(current_visitor)
	tween = create_tween()
	tween.tween_property(current_visitor, "position", door.position, 0.5*scale())
	await get_tree().create_timer(0.5*scale()-0.8).timeout
	door_state.emit(true)
	await get_tree().create_timer(0.2).timeout
	timeout = false
	tim = Timer.new()
	tim.timeout.connect(_timeout)
	tim.one_shot = true
	add_child(tim)
	tim.start(1+scale())

func _timeout():
	timeout = true
	remove_child(tim)
	door_state.emit(false)
	remove_child(current_visitor)
	visitor_count += 1
	visit.emit(visitor_count)
	mean = scale()
	length = clamp(randfn(mean, deviation), mean - 4 * deviation, mean + 4 * deviation)
	await get_tree().create_timer(length).timeout
	spawn_visitor()

func button_pressed(candy: String):
	if timeout:
		return
	timeout = true
	if candy in current_visitor.desired_candy:
		score+=10
		score += roundi(tim.time_left*5)
	tim.stop()
	remove_child(tim)
	door_state.emit(false)
	visitor_count += 1
	visit.emit(visitor_count)
	mean = scale()
	length = clamp(randfn(mean, deviation), mean - 4 * deviation, mean + 4 * deviation)
	await get_tree().create_timer(length).timeout
	remove_child(current_visitor)
	spawn_visitor()

func _ready() -> void:
	spawn_visitor()
