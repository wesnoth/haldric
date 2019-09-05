extends Node2D

const DEFAULT_USER_PATH = "user://data/editor/scenarios/"
const DEFAULT_ROOT_PATH = "res://data/scenarios/"
const DEFAULT_MAP_SIZE := Vector2(44, 33)

export var button_size := 60

onready var HUD := $HUD as CanvasLayer
onready var scenario_container := $ScenarioContainer as Node
onready var line_edit := $HUD/UIButtons/HBoxContainer/LineEdit as LineEdit

var scenario: Scenario = null
var current_paint_tile := 0
var current_clear_tile := 0

func _unhandled_input(event: InputEvent) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()

	if Input.is_action_pressed("mouse_left"):
		scenario.map.set_tile(mouse_position, current_paint_tile)

	if Input.is_action_pressed("mouse_right"):
		scenario.map.set_tile(mouse_position, current_clear_tile)

	if Input.is_action_just_released("mouse_left") or Input.is_action_just_released("mouse_right"):
		_update()

func _ready() -> void:
	_new_map()
	_setup_scenario()

	current_clear_tile = scenario.map.default_tile

func _update() -> void:
	scenario.map.update_terrain()

func _setup_scenario() -> void:
	for id in scenario.map.tile_set.get_tiles_ids():
		_add_terrain_button(id)

func _add_terrain_button(id: int) -> void:
	var button := TextureButton.new()
	#warning-ignore:return_value_discarded
	button.connect("pressed", self, "_on_button_pressed", [id])
	var texture := AtlasTexture.new()
	texture.atlas = scenario.map.tile_set.tile_get_texture(id)
	texture.region = _normalize_region(scenario.map.tile_set.tile_get_region(id))
	button.texture_normal = texture
	button.rect_size = Vector2(54, 72)
	button.button_mask = BUTTON_MASK_LEFT | BUTTON_MASK_RIGHT
	HUD.add_button(button)

func _normalize_region(region : Rect2) -> Rect2:
	var rect_position = (region.position + (region.size / 2.0)) -\
			Vector2(button_size / 2.0, button_size / 2.0)
	var rect = Rect2(rect_position, Vector2(button_size, button_size))

	return rect

func _new_map() -> void:
	if scenario:
		scenario_container.remove_child(scenario)
		scenario.queue_free()

	scenario = Wesnoth.Scenario.instance()
	scenario_container.add_child(scenario)
	scenario.map.set_size(DEFAULT_MAP_SIZE)
	scenario.update_size()

func _load_map(scenario_name: String) -> void:
	var packed_scene = load(DEFAULT_ROOT_PATH + scenario_name + ".tscn")

	if packed_scene == null:
		packed_scene = load(DEFAULT_USER_PATH + scenario_name + ".tscn")

	if packed_scene == null:
		return

	scenario_container.remove_child(scenario)
	scenario.queue_free()

	scenario = packed_scene.instance()
	scenario_container.add_child(scenario)

func _save_map(scenario_name: String) -> void:
	if scenario_name.empty():
		print("No scenario name set!")
		return

	var id = scenario_name.replace(" ", "_").to_lower()
	var scn_path: String = DEFAULT_USER_PATH + id + ".tscn"
	var res_path: String = DEFAULT_USER_PATH + id + ".tres"

	scenario.name = scenario_name

	var packed_scene := PackedScene.new()

	#warning-ignore:return_value_discarded
	packed_scene.pack(scenario)

	var r_scenario := RScenario.new()
	r_scenario.title = scenario_name

	if ResourceSaver.save(scn_path, packed_scene) != OK:
		print("Failed to save map scene ", scn_path)
	elif ResourceSaver.save(res_path, r_scenario) != OK:
		print("Failed to save map resource", res_path)
	else:
		Registry.register_scenario(id, r_scenario, scn_path)

func _on_button_pressed(id: int) -> void:
	if Input.is_action_just_released("mouse_left"):
		current_paint_tile = id

	if Input.is_action_just_released("mouse_right"):
		current_clear_tile = id

func _on_Save_pressed() -> void:
	_save_map(line_edit.text)

func _on_Load_pressed() -> void:
	_load_map(line_edit.text)

func _on_New_pressed() -> void:
	_new_map()
