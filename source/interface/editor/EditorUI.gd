extends CanvasLayer
class_name EditorUI

signal terrain_selected(code)

onready var terrain_buttons := $HUD/PanelContainer/GridContainer
onready var selector := $HUD/Selector
onready var tween := $Tween


func _ready() -> void:
	for code in Data.terrains:
		var terrain : TerrainData = Data.terrains[code]
		_add_terrain_button(terrain)


func _add_terrain_button(terrain: TerrainData) -> void:
	var button := EditorTerrainButton.instance()
	terrain_buttons.add_child(button)
	button.texture = terrain.graphic.texture
	button.connect("pressed", self, "_on_terrain_button_selected", [ button, terrain.code ])


func highlight(button: Button) -> void:
	tween.stop_all()
	tween.interpolate_property(selector, "rect_global_position", selector.rect_global_position, button.rect_global_position, 0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(selector, "rect_size", selector.rect_size, button.rect_size, 0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()


func _on_terrain_button_selected(button: Button, code : String) -> void:
	highlight(button)
	emit_signal("terrain_selected", code)
