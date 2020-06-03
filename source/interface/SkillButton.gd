extends Button
class_name SkillButton


static func instance() -> SkillButton:
	return load("res://source/interface/SkillButton.tscn").instance() as SkillButton


func update_info(skill: Skill) -> void:
	text = skill.alias
	hint_tooltip = skill.description
