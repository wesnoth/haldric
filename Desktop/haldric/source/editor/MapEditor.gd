extends Node2D
class_name MapEditor

enum PaintMode { PLAYER, TERRAIN }

var map : Map = null

var hovered_location : Location = null
var last_location : Location = null

var paint_mode : int = PaintMode.TERRAIN

var active_terrain := ""
var active_overlay := ""

var active_brush_size := 0

var active_player := 0

var players := {}


func _ready() -> void:
	new_map(40, 40)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if hovered_location != last_location:
			if paint_mode == PaintMode.TERRAIN:
				edit_locations(map.get_locations_in_range(hovered_location.cell, active_brush_size))
			elif paint_mode == PaintMode.PLAYER:
				set_player(hovered_location)
			last_location = hovered_location


func new_map(width: int, height: int) -> void:
	if map:
		remove_child(map)
		map.queue_free()
		map = null

	var map_data := MapData.new()
	map_data.create(width, height, [ "Gg" ])

	map = Map.instance()
	map.initialize(map_data)
	add_child(map)

	Console.write("New Map: %dx%d" % [width, height])
	map.connect("location_hovered", self, "_on_location_hovered")


func edit_locations(locs: Array) -> void:

	for loc in locs:
		edit_location(loc)

	map.refresh()


func edit_location(loc: Location) -> void:

	if Input.is_action_pressed("edit_base_only"):
		loc.set_base_code(active_terrain)

	else:
		if active_terrain:
			var code = [active_terrain]
			map.set_location_terrain(loc, code)

		if active_overlay:
			var code = [ loc.terrain.get_base_code(), active_overlay ]
			map.set_location_terrain(loc, code)


func set_player(loc: Location):
	players[active_player] = loc.cell
	Console.write("Player 1: %s" % str(loc.cell))


func _on_location_hovered(loc: Location) -> void:
	hovered_location = loc
	get_tree().call_group("Selector", "update_info", hovered_location)


func _on_EditorUI_terrain_selected(code: String) -> void:
	if code.begins_with("^"):
		active_overlay = code
	else:
		active_terrain = code
		active_overlay = ""


func _on_EditorUI_save_pressed(file_name: String) -> void:
	if not file_name:
		Console.write("Please provie a filename!")

	var data = map.get_map_data()
	data.players = players
	ResourceSaver.save("res://data/maps/" + file_name + ".tres", data)


func _on_EditorUI_mode_changed(mode: int) -> void:
	paint_mode = mode


func _on_EditorUI_player_selected(player: int) -> void:
	active_player = player


func _on_EditorUI_brush_size_selected(size: int) -> void:
	active_brush_size = size - 1


func _on_EditorUI_new_map_pressed(width: int, height: int) -> void:
	new_map(width, height)
