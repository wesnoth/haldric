extends Control
class_name Selector

onready var defense_label := $TextureRect/Defense

func update_info(loc: Location, selected_unit: Location = null) -> void:
	rect_global_position = loc.position

	if selected_unit and selected_unit.unit and not loc.unit:
		defense_label.text = "%d %%" % selected_unit.unit.get_defense(loc.terrain.type)
		defense_label.show()
	else:
		defense_label.hide()
