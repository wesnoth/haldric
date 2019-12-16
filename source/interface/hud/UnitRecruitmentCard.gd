extends Control

signal unit_recruitment_card_clicked

onready var avatar := $UnitRecruitmentCardHbox/Avatar as TextureRect
onready var name_label := $UnitRecruitmentCardHbox/VBoxContainer/NameLabel as Label
onready var cost_label := $UnitRecruitmentCardHbox/VBoxContainer/HBoxContainer/CostLabel as Label
var unit_type_id: String

func initialize(unit_type_id: String) -> void:
	self.unit_type_id = unit_type_id
	var unit_type: PackedScene = Registry.units[unit_type_id].instance()
	avatar.texture = unit_type.find_node("Sprite").texture
	name_label.text = unit_type.name
	cost_label.text = str(unit_type.cost)

func _gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("unit_recruitment_card_clicked", unit_type_id)
