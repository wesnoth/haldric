extends Button
class_name RecallOption


static func instance() -> RecallOption:
	return load("res://source/interface/game/recall/RecallOption.tscn").instance() as RecallOption


func update_info(side: Side, unit_type: UnitType, data: Dictionary) -> void:
	text = "%s (20G)" % unit_type.alias

	if side.gold < 20:
		disabled = true
