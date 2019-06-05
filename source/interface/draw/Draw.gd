extends Node2D

onready var fog := $Fog
onready var fog_texture := $Fog/Viewport/FogTexture
onready var outline := $Outline as Node2D
onready var unit_path_display := $UnitPathDisplay as Path2D

var map_area := Vector2() setget on_map_area_set

func _ready() -> void:
	# warning-ignore:return_value_discarded
	Event.connect("move_to", self, "_on_move_to")
	# warning-ignore:return_value_discarded
	Event.connect("turn_refresh", self, "_on_turn_refresh")
	# warning-ignore:return_value_discarded
	Event.connect("turn_end", self, "_on_turn_end")

func _draw() -> void:
	var side := 0

	if Global.state.current_side:
		side = Global.state.current_side.number
		fog_texture.side = Global.state.current_side
	fog_texture.side_number = side
	fog_texture.units = get_tree().get_nodes_in_group("Unit")
	fog_texture.update()

	# outline.texture = viewport.get_texture()
	# outline.update()

func on_map_area_set(val: Vector2) -> void:
	fog.rect_size = val

func set_path(path) -> void:
	unit_path_display.path = path

func _on_move_to(unit: Unit, location: Location) -> void:
	update()

func _on_turn_refresh(turn: int, side: int) -> void:
	update()

func _on_turn_end(turn: int, side: int) -> void:
	update()
