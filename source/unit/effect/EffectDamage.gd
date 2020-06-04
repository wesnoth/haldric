extends Effect
class_name EffectDamage

export var damage = 0
export var damage_type = ""

func _execute(unit: Unit) -> void:
	unit.hurt(damage, damage_type)
