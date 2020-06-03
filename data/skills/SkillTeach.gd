extends Skill
class_name SkillTeach

export var amount := 2


func _execute(target: Location) -> void:
	target.unit.grand_experience(amount)
