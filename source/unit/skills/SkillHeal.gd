extends Skill
class_name SkillHeal

export var amount := 4


func _execute(target: Location) -> void:
	target.unit.heal(amount)
