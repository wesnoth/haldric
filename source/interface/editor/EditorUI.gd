extends CanvasLayer
class_name EditorUI

signal mode_changed(mode)

signal terrain_selected(code)
signal player_selected(player)
signal brush_size_selected(size)

signal new_map_pressed(width, height)
signal save_pressed(file_name)

var MODE_BUTTON_GROUP := ButtonGroup.new()

onready var terrain_buttons := $HUD/PanelContainer/VBoxContainer/TerrainButtons
onready var mode_buttons := $HUD/PanelContainer/VBoxContainer/ModeButtons

onready var terrain_selector := $HUD/TerrainSelector
onready var tween := $Tween

onready var player_label := $HUD/PanelContainer/VBoxContainer/PlayerLabel
onready var brush_label := $HUD/PanelContainer/VBoxContainer/BrushSizeLabel

onready var save_edit := $HUD/PanelContainer/VBoxContainer/Save/LineEdit
onready var width_edit := $HUD/PanelContainer/VBoxContainer/NewMap/Width/LineEdit
onready var height_edit := $HUD/PanelContainer/VBoxContainer/NewMap/Height/LineEdit

onready var create_button := $HUD/PanelContainer/VBoxContainer/NewMap/Button

var width_value: int
var height_value: int

func _ready() -> void:
	_add_mode_button("Terrain", "_on_terrain_mode_selected")
	_add_mode_button("Player", "_on_player_mode_selected")

	for code in Data.terrains:
		var terrain : TerrainData = Data.terrains[code]
		_add_terrain_button(terrain)

	call_deferred("reset_selector")


func reset_selector() -> void:
	terrain_selector.rect_global_position = terrain_buttons.get_child(0).rect_global_position
	terrain_selector.rect_size = terrain_buttons.get_child(0).rect_size


func _add_mode_button(text: String, callback: String) -> void:
	var button = Button.new()
	button.text = text
	button.rect_min_size.y = 40
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.toggle_mode = true
	button.focus_mode = Control.FOCUS_NONE
	button.group = MODE_BUTTON_GROUP
	button.connect("pressed", self, callback)
	mode_buttons.add_child(button)


func _add_terrain_button(terrain: TerrainData) -> void:
	var button := EditorTerrainButton.instance()
	terrain_buttons.add_child(button)
	button.texture = terrain.graphic.texture
	button.connect("pressed", self, "_on_terrain_button_selected", [ button, terrain.code ])


func highlight(button: Button) -> void:
	tween.stop_all()
	tween.interpolate_property(terrain_selector, "rect_global_position", terrain_selector.rect_global_position, button.rect_global_position, 0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(terrain_selector, "rect_size", terrain_selector.rect_size, button.rect_size, 0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func validate_create_button() -> void:
	print(width_value)
	print(height_value)
	if width_value > 0 and height_value > 0 and create_button.disabled:
		create_button.disabled = false
	elif not create_button.disabled and width_value <= 0 or height_value <= 0:
		create_button.disabled = true

func _on_player_mode_selected() -> void:
	emit_signal("mode_changed", MapEditor.PaintMode.PLAYER)


func _on_terrain_mode_selected() -> void:
	emit_signal("mode_changed", MapEditor.PaintMode.TERRAIN)


func _on_terrain_button_selected(button: Button, code : String) -> void:
	highlight(button)
	emit_signal("terrain_selected", code)


func _on_Save_pressed() -> void:
	emit_signal("save_pressed", save_edit.text)


func _on_PlayerSlider_value_changed(value: float) -> void:
	player_label.text = "Player: %d" % value
	emit_signal("player_selected", value - 1)


func _on_BrushSizeSlider_value_changed(value: float) -> void:
	brush_label.text = "Brush Size: %d" % value
	emit_signal("brush_size_selected", value)


func _on_NewMap_pressed() -> void:
	width_edit.release_focus()
	height_edit.release_focus()
	emit_signal("new_map_pressed", int(width_edit.text), int(height_edit.text))


func _on_Quit_pressed() -> void:
	Scene.change("TitleScreen")

func _on_MapWidthInput_text_changed(new_text):
	width_value = int(new_text)
	validate_create_button()

func _on_MapHeightInput_text_changed(new_text):
	height_value = int(new_text)
	validate_create_button()

