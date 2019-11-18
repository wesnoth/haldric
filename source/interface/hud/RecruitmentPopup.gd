extends Popup

signal unit_recruitment_requested

const UnitRecruitmentCard = preload("res://source/interface/hud/UnitRecruitmentCard.tscn")
onready var units_container := $UnitsListContainer as VBoxContainer

var initialized := false

func _ready():
	connect("popup_hide", self, "_on_popup_hide")

func show_popup(unit_types : Array) -> void:
	for unit_type in unit_types:
		var card := UnitRecruitmentCard.instance()
		card.connect("unit_recruitment_card_clicked", self, "_on_unit_recruitment_card_clicked")
		units_container.add_child(card)
		card.initialize(unit_type)
	popup()

func _on_unit_recruitment_card_clicked(unit_type : UnitType) -> void:
	emit_signal("unit_recruitment_requested", unit_type)

	hide()

func _on_popup_hide():
	for child in units_container.get_children():
		child.queue_free()
