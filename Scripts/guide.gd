extends TextureButton

@export var speed: float
@export_category("Position")
@export var closed: Vector2
@export var open: Vector2

var tween: Tween
var opened: bool = false

func _ready():
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(texture_normal.get_image())
	texture_click_mask = bitmap

func _on_pressed():
	opened = not opened
	tween = create_tween()
	if opened:
		tween.tween_property($".", "position", open, speed)
	else:
		tween.tween_property($".", "position", closed, speed)
