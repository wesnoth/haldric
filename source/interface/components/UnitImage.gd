extends Control

onready var unit_sprite = $"Sprite"

func update_image(texture, mat):
	var x = 65 + 72 - texture.get_width()
	unit_sprite.texture = texture
	unit_sprite.position = Vector2(x, 40)
	unit_sprite.set_material(mat)
	show()

func clear_image():
	hide()
	unit_sprite.texture = null