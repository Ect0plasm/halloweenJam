extends TextureButton

@onready var texture = load("res://Scenes/mushroom.tres")
var count = 3
signal press(candy: String)

func _ready():
	texture_normal = texture.get_frame_texture("default",count)

func _on_pressed():
		if count < 1:
			count = 3
		else:
			if not $"../../GameController".timeout:
				count -= 1
				press.emit("Fungus")
		texture_normal = texture.get_frame_texture("default",count)
