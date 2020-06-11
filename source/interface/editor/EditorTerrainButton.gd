extends Button
class_name EditorTerrainButton

var texture : Texture = null setget _set_texture

onready var rect := $TextureRect


static func instance() -> EditorTerrainButton:
	return load("res://source/interface/editor/EditorTerrainButton.tscn").instance() as EditorTerrainButton


func _ready() -> void:
	_set_texture(texture)


func _set_texture(tex: Texture) -> void:
	texture = tex
	if rect:
		rect.texture = tex
