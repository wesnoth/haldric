extends CanvasLayer
class_name GameUI

signal recruit_selected()
signal move_selected(loc)
signal skill_selected(skill)

signal combat_option_selected(attacker_attack, defender_attack, target)
signal recruit_option_selected(unit_type_id)

signal end_turn_pressed()

var cover_cells := []
var hover_path := []

var shows_actions := false

onready var selector := $Selector

onready var unit_plate_container := $UnitPlateContainer
onready var popup_label_container := $PopupLabelContainer

onready var cover := $Cover as TileMap
onready var COVER_TILE : int = cover.tile_set.find_tile_by_name("darken")

onready var path_ui := $PathUI as PathUI

onready var action_dialogue := $ActionDialogue as ActionDialogue
onready var combat_dialogue := $HUD/CombatDialogue as CombatDialogue
onready var recruit_dialogue := $HUD/RecruitDialogue as RecruitDialogue
onready var advancement_dialogue := $HUD/AdvancementDialogue as AdvancementDialogue

onready var time_label := $HUD/Panels/SidePanel/VBoxContainer/TimeOfDay

func _ready() -> void:
	combat_dialogue.hide()
	recruit_dialogue.hide()
	advancement_dialogue.hide()
	cover.hide()


func spawn_popup_label(position: Vector2, text: String, font_size := 16, color := Color("FFFFFFFF"), distance := 160, time := 0.6) -> void:
	var popup := PopupLabel.instance()
	popup.font_size = font_size
	popup.color = color
	popup.text = text
	popup.time = time
	popup.distance = distance
	popup.rect_global_position = position
	popup_label_container.add_child(popup)


func show_hover_path(path: Array) -> void:
	if hover_path:
		path_ui.erase(hover_path)
	path_ui.show_path(path)
	hover_path = path


func hide_hover_path() -> void:
	if hover_path:
		path_ui.erase(hover_path)
	hover_path = []


func add_path(path: Array) -> void:
	path_ui.show_path(path)


func remove_path(path: Array) -> void:
	path_ui.erase(path)


func show_action_dialogue(loc: Location) -> void:
	if not loc.unit:
		return

	shows_actions = true
	selector.hide()
	action_dialogue.update_info(loc)


func hide_action_dialogue() -> void:
	action_dialogue.clear()
	selector.show()
	shows_actions = false


func show_combat_dialogue(time: Time, attacker: Location, defender: Location) -> void:
	selector.hide()
	combat_dialogue.update_info(time, attacker, defender)
	combat_dialogue.show()


func close_combat_dialogue() -> void:
	selector.show()
	combat_dialogue.hide()
	combat_dialogue.clear()


func show_recruit_dialogue(side: Side) -> void:
	selector.hide()
	recruit_dialogue.update_info(side)
	recruit_dialogue.show()


func close_recruit_dialogue() -> void:
	selector.show()
	recruit_dialogue.hide()
	recruit_dialogue.clear()


func show_advancement_dialogue(unit: Unit) -> void:
	advancement_dialogue.update_info(unit)
	advancement_dialogue.show()


func set_cover_size(size: Vector2) -> void:
	for y in size.y:
		for x in size.x:
			cover.set_cell(x, y, COVER_TILE)


func show_cover(cells: Array) -> void:

	for cell in cells:
		cover.set_cellv(cell, TileMap.INVALID_CELL)

	cover_cells = cells
	cover.show()


func hide_cover() -> void:

	for cell in cover_cells:
		cover.set_cellv(cell, COVER_TILE)

	cover_cells = []
	cover.hide()


func add_unit_plate(unit: Unit) -> void:
	var plate := UnitPlate.instance()
	unit_plate_container.add_child(plate)
	plate.initialize(unit)
	unit.attach_unit_plate(plate)


func _on_CombatDialogue_option_selected(attacker_attack: Attack, defender_attack: Attack, target: Location) -> void:
	close_combat_dialogue()
	emit_signal("combat_option_selected", attacker_attack, defender_attack, target)


func _on_CombatDialogue_cancelled() -> void:
	close_combat_dialogue()


func _on_EndTurn_pressed() -> void:
	emit_signal("end_turn_pressed")


func _on_RecruitDialogue_cancelled() -> void:
	close_recruit_dialogue()


func _on_RecruitDialogue_option_selected(unit_type_id: String) -> void:
	close_recruit_dialogue()
	emit_signal("recruit_option_selected", unit_type_id)


func _on_ActionDialogue_move_selected(loc) -> void:
	emit_signal("move_selected", loc)


func _on_ActionDialogue_recruit_selected() -> void:
	emit_signal("recruit_selected")


func _on_ActionDialogue_skill_selected(skill) -> void:
	emit_signal("skill_selected", skill)
