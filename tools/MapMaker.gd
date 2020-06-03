tool
extends Node2D

export var build_tileset := false setget _build_tileset

onready var map := $Map as Map
onready var overlay := $Map/Overlay as TileMap


func _enter_tree() -> void:
	if Engine.editor_hint:
		map = $Map as Map
		overlay = $Map/Overlay as TileMap


func _build_tileset(__) -> void:
	if Engine.editor_hint:
		var tile_set = TileSetBuilder.build(_terrain())
		map.tile_set = tile_set
		overlay.tile_set = tile_set


func _terrain() -> Dictionary:
	var graphics := {}

	for file_data in Loader.load_dir("res://data/terrain", ["tres", "res"]):
		var code = file_data.data.code
		graphics[code] = file_data.data
		print("Loading: ", file_data)
	return graphics


func _build_map_data() -> MapData:
	var map_data := MapData.new()

	for y in map.get_used_rect().size.y:
		for x in map.get_used_rect().size.x:
			var base_id = map.get_cell(x, y)
			var overlay_id = overlay.get_cell(x, y)

			var code := [map.tile_set.tile_get_name(base_id)]

			if not overlay_id == TileMap.INVALID_CELL:
				code.append(overlay.tile_set.tile_get_name(overlay_id))

			var cell = Vector2(x, y)
			map_data.data[cell] = code

	return map_data


func _on_Save_pressed() -> void:
	var map_data := _build_map_data()
	ResourceSaver.save("res://data/maps/map.tres", map_data)
