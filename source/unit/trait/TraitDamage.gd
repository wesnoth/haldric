extends Trait
class_name TraitDamage

export var bonus_damage := 1
export var category := ""

func _execute(unit: Unit) -> void:
	for attack in unit.get_attacks():
		if attack.category == category:
			attack.damage += bonus_damage
