extends Node2D
class_name MapEditor

var map : Map = null

var hovered_location : Location = null
var last_location : Location = null

var active_terrain := ""
var active_overlay := ""

func _ready() -> void:
	new_map(40, 40)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if hovered_location != last_location:
			edit_location(hovered_location)


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

	map.connect("location_hovered", self, "_on_location_hovered")


func edit_location(loc: Location) -> void:

	if Input.is_action_pressed("edit_base_only"):
		loc.set_base_code(active_terrain)
	else:
		if active_terrain:
			loc.set_base_code(active_terrain)
			loc.remove_overlay_code()
		if active_overlay:
			loc.set_overlay_code(active_overlay)

	map.refresh()


func _on_location_hovered(loc: Location) -> void:
	last_location = hovered_location
	hovered_location = loc


func _on_EditorUI_terrain_selected(code: String) -> void:
	if code.begins_with("^"):
		active_overlay = code
	else:
		active_terrain = code
		active_overlay = ""
