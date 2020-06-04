extends Effect
class_name EffectDamage

export var damage = 0
export var damage_type = Attack.DamageType.NONE

func _execute(target: Location) -> void:
	target.unit.hurt(damage, damage_type)
