extends Node2D

onready var viewport := $Viewport as Viewport

onready var fog_texture := $Viewport/FogTexture as Node2D
onready var fog := $Fog as Node2D

onready var unit_path_display := $UnitPathDisplay as Path2D

onready var hover := $Hover as Sprite

onready var map_border := $MapBorder

func _process(delta: float) -> void:
	var size = map_border.rect_size
	var side = get_parent().current_side.number

	viewport.size = size
	fog_texture.side = side
	fog.texture = viewport.get_texture()

func update_units(units: Array) -> void:
	fog_texture.units = units

func update_map_border(size) -> void:
	map_border.rect_size = size

func update_hover(new_position: Vector2) -> void:
	hover.position = new_position

func update_path(path) -> void:
	unit_path_display.path = path