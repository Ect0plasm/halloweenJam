extends AnimatedSprite2D

func _update(value: int):
	if value > 20:
		print($"../GameController".score)
	if value > 12:
		frame = 3
		return
	if value > 6:
		frame = 2
		return
	if value > 2:
		frame = 1
		return
