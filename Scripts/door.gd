extends AnimatedSprite2D

func door_state(state: bool):
	if state:
		play("default", 1.0)
	else:
		play("default", -1.0)
