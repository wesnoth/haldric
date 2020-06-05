extends Button
class_name AdvancemenOption


static func instance() -> AdvancemenOption:
	return load("res://source/interface/game/advancement/AdvancementOption.tscn").instance() as AdvancemenOption


func update_info(advancement: Advancement) -> void:
	text = "%s" % advancement.alias
