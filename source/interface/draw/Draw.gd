extends Node2D

onready var viewport := $Viewport as Viewport

onready var fog_texture := $Viewport/FogTexture as Node2D
onready var fog := $Fog as Node2D

onready var outline := $Outline as Node2D

onready var unit_path_display := $UnitPathDisplay as Path2D

onready var hover := $Hover as Sprite

onready var map_border := $MapBorder

func _ready() -> void:
	Event.connect("move_to", self, "_on_move_to")
	Event.connect("turn_refresh", self, "_on_turn_refresh")
	Event.connect("turn_end", self, "_on_turn_end")

func _draw() -> void:
	var size = map_border.rect_size
	var side = get_parent().current_side.number
	viewport.size = size
	fog_texture.side = side
	fog_texture.units = get_tree().get_nodes_in_group("Unit")
	fog_texture.update()
	fog.texture = viewport.get_texture()
	fog.update()
	outline.texture = viewport.get_texture()
	outline.update()
	print("STUFF")

func set_map_border_size(size) -> void:
	map_border.rect_size = size

func set_hover_position(new_position: Vector2) -> void:
	hover.position = new_position

func set_path(path) -> void:
	unit_path_display.path = path

func _on_move_to(unit: Unit, location: Location) -> void:
	update()

func _on_turn_refresh(turn: int, side: int) -> void:
	update()

func _on_turn_end(turn: int, side: int) -> void:
	update()