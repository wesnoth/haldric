extends Button
class_name RecruitOption


static func instance() -> RecruitOption:
	return load("res://source/interface/recruit/RecruitOption.tscn").instance() as RecruitOption


func update_info(side: Side, unit_type: UnitType) -> void:
	text = "%s (%dG)" % [unit_type.alias, unit_type.cost]

	if side.gold < unit_type.cost:
		disabled = true
