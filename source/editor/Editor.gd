extends Node2D

const SCENARIO = preload("res://source/core/scenario/Scenario.tscn")
const default_path = "res://data/scenarios/"

onready var HUD = $HUD
onready var scenario_container = $ScenarioContainer
onready var scenario = $ScenarioContainer/Scenario
onready var map = $ScenarioContainer/Scenario/Map
onready var line_edit = $HUD/UIButtons/HBoxContainer/LineEdit

var current_tile = 0

func _unhandled_input(event) -> void:
	if Input.is_action_pressed("mouse_left"):
		var mouse_position = get_global_mouse_position()
		map.set_tile(mouse_position, current_tile)
	
	if Input.is_action_pressed("mouse_right"):
		var mouse_position = get_global_mouse_position()
		map.set_tile(mouse_position, -1)

func _ready() -> void:
	load_map("res://data/scenarios/test.tscn")
	_setup_scenario()

func _setup_scenario():
	map.get_node("MapBorder").hide()
	for id in map.tile_set.get_tiles_ids():
		_add_terrain_button(id)

func _add_terrain_button(id : int) -> void:
	var button = TextureButton.new()
	button.connect("pressed", self, "_on_button_pressed", [ id ])
	var texture = AtlasTexture.new()
	texture.atlas = map.tile_set.tile_get_texture(id)
	texture.region = map.tile_set.tile_get_region(id)
	button.texture_normal = texture
	button.rect_size = Vector2(54, 72)
	HUD.add_button(button)

func new_map():
	scenario.free()
	scenario = SCENARIO.instance()
	scenario_container.add_child(scenario)

func load_map(scenario_name):
	var packed_scene = load(default_path + scenario_name + ".tscn")
	
	if packed_scene == null:
		return
	
	scenario.free()
	scenario = packed_scene.instance()
	scenario_container.add_child(scenario)
	_setup_scenario()

func _save_map(scenario_name):
	var packed_scene = PackedScene.new()
	packed_scene.pack(scenario)
	ResourceSaver.save(default_path + scenario_name + ".tscn", packed_scene)
	Registry.scan()

func _on_button_pressed(id):
	print(id)
	current_tile = id

func _on_Back_pressed():
	Scene.change(Scene.TitleScreen)

func _on_Save_pressed():
	_save_map(line_edit.text)

func _on_Load_pressed():
	load_map(line_edit.text)

func _on_New_pressed():
	new_map()
