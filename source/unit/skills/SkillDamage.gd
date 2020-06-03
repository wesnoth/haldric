extends Skill
class_name SkillDamage

export var damage := 0
export(Attack.DAMAGE_TYPE) var damage_type := Attack.DAMAGE_TYPE.NONE


func _execute(target: Location) -> void:
	target.unit.hurt(damage, damage_type)
