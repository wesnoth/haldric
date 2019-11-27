tool
extends Control
class_name Circle

export var color := Color("000000")  setget _set_color
export var border_color := Color("FFFFFF")  setget _set_border_color

export var border_width := 1 setget _set_border_width

var outer_circle : TextureRect
var inner_circle : TextureRect
var margin : MarginContainer

func _ready() -> void:
	outer_circle = $OuterCircle
	inner_circle = $MarginContainer/InnerCircle
	margin = $MarginContainer

	_set_color(color)
	_set_border_color(border_color)
	_set_border_width(border_width)

func _set_color(new_color: Color) -> void:
	color = new_color
	if inner_circle:
		inner_circle.self_modulate = color

func _set_border_color(new_color: Color) -> void:
	border_color = new_color
	if outer_circle:
		outer_circle.self_modulate = border_color

func _set_border_width(width: int) -> void:
	border_width = width
	if margin:
		margin.set("custom_constants/margin_left", width)
		margin.set("custom_constants/margin_right", width)
		margin.set("custom_constants/margin_top", width)
		margin.set("custom_constants/margin_bottom", width)
