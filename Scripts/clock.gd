extends AnimatedSprite2D

func _update(value: int):
	if value > 20:
		done($"../../GameController".score)
		return
	if value > 12:
		frame = 3
		return
	if value > 6:
		frame = 2
		return
	if value > 2:
		frame = 1
		return

func done(score: int):
	$"../../End/Score".text = "Score: %s" % score
	$"../../End".visible = true
	get_tree().paused = true
	await get_tree().create_timer(15.0).timeout
	get_tree().quit()
