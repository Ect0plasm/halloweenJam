extends Node

@export var initial_position: Vector2
@export var grumble: Array[AudioStream]
@export_category("Visitors")
@export var humans: Array[PackedScene]
@export var monsters: Array[PackedScene]
@export var hidden_monsters: Array[PackedScene]

@onready var door = $"../Background/Door"
@onready var brightness = $"../CanvasModulate"
@onready var player = $"../Audio/Grumble"
@onready var yipee = load("res://Assets/Sfx/yippee.mp3")

signal visit(count: int)
signal door_state(state: bool)

var current_visitor

var timeout: bool
var tween: Tween
var count: int
var last = -1
var visitor_count = 0
var mean: float
var length: int
const deviation = 0.25
var score = 0
var tim: Timer
@onready var all_monsters = monsters + hidden_monsters

func scale() -> float:
	return max(4-(0.2*visitor_count), 2)

func get_random() -> int:
	var rand = randi_range(0, count-1)
	if rand >= last:
		rand = (rand+1) % (count-1)
	last = rand
	return rand

func spawn_visitor():
	if visitor_count < 3:
		count = len(humans)
		current_visitor = humans[get_random()].instantiate()
	elif visitor_count < 6:
		count = len(monsters)
		current_visitor = monsters[get_random()].instantiate()
	else:
		count = len(all_monsters)
		current_visitor = all_monsters[get_random()].instantiate()
		
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
	

func button_pressed(candy: String):
	if timeout:
		return
	if candy in current_visitor.desired_candy:
		score+=10
		score += roundi(tim.time_left*5)
		if randi_range(1, 40) == 1:
			player.stream = yipee
			player.play()
	else:
		player.stream = grumble.pick_random()
		player.play()
	done()

func _timeout():
	player.stream = grumble.pick_random()
	player.play()
	done()

func done():
	timeout = true
	tim.stop()
	remove_child(tim)
	door_state.emit(false)
	visitor_count += 1
	visit.emit(visitor_count)
	tween = create_tween()
	tween.tween_property(brightness, "color", brightness.color*Color(0.95,0.95,0.95,1), 2)
	mean = scale()
	length = clamp(randfn(mean, deviation), mean - 4 * deviation, mean + 4 * deviation)
	await get_tree().create_timer(length).timeout
	remove_child(current_visitor)
	spawn_visitor()
	

func _ready():
	spawn_visitor()
