extends AnimatedSprite2D

@onready var open = load("res://Assets/Sfx/door_open.wav")
@onready var close = load("res://Assets/Sfx/door_close.wav")
@onready var player = $"../Audio/Door"

func door_state(state: bool):
	if state:
		play("default", 1.0)
		player.stream = open
	else:
		play("default", -1.0)
		player.stream = close
	player.play()
