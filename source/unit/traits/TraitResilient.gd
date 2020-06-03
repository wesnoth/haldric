extends Trait
class_name TraitResilient

export var health_bonus := 4
export var health_bonus_per_level := 1

func _execute(unit: Unit) -> void:
	unit.health.maximum += health_bonus + health_bonus_per_level * unit.type.level
