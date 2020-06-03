extends Button
class_name AdvancemenOption


static func instance() -> AdvancemenOption:
	return load("res://source/interface/advancement/AdvancementOption.tscn").instance() as AdvancemenOption


func update_info(unit_type: UnitType) -> void:
	text = "%s" % [unit_type.alias]
