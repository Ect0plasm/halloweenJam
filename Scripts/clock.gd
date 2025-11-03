extends Node

func _ready() -> void:
	get_node("GameController").visit.connect(_update)

func _update(value: int):
	value
	pass
