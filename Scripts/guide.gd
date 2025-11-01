extends TextureButton

@export var closed: Vector2
@export var open: Vector2
@export var speed: float

var tween: Tween
var opened: bool = false

func _ready():
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(self.texture_normal.get_image())
	self.texture_click_mask = bitmap

func _on_pressed():
	opened = not opened
	tween = create_tween()
	if opened:
		tween.tween_property($".", "position", open, speed)
	else:
		tween.tween_property($".", "position", closed, speed)
