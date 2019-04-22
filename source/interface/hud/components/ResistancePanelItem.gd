extends HBoxContainer

var value setget _set_value

export var icon_texture : StreamTexture
export var region := Rect2()

onready var texture_rect := $TextureRect as TextureRect
onready var label := $Label as Label

func _ready() -> void:
	var tex := AtlasTexture.new()
	tex.atlas = icon_texture
	tex.region = region
	texture_rect.texture = tex
	label.text = "-"

func _set_value(value: int) -> void:
	label.modulate = _get_resistance_color(value)
	if value > 0:
		label.text = "+%d%%" % value
	else:
		label.text = "%d%%" % value

func _get_resistance_color(resistance: int) -> Color:
	if resistance == 0:
		return Color(1, 1, 1)
	elif resistance > 0:
		var mod = float(resistance) * 0.01
		return Color(1.0 - mod, 1.0, 1.0 - mod)
	else:
		var mod = float(100 + resistance) * 0.01
		return Color(1.0, mod, mod)
