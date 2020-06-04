extends Skill
class_name SkillDamage

export var damage := 0
export(Attack.DamageType) var damage_type := Attack.DamageType.NONE


func _execute(target: Location) -> void:
	target.unit.hurt(damage, damage_type)
