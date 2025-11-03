extends TextureButton

@export var initial_count: int
@export var candy: String
@export var texture: SpriteFrames


var count: int
signal press(candy: String)

func _ready():
	count = initial_count
	texture_normal = texture.get_frame_texture("default",count)
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(texture_normal.get_image())
	texture_click_mask = bitmap


func _on_pressed():
	if count < 1:
		count = initial_count
	else:
		if not $"../../GameController".timeout:
			count -= 1
			press.emit(candy)
	texture_normal = texture.get_frame_texture("default",count)
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(texture_normal.get_image())
	texture_click_mask = bitmap
