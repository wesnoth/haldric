extends Ability
class_name AbilityHeal

export var amount := 4
export(Array, String) var cure := []

func _execute(target: Location) -> void:
	target.unit.heal(amount, true)
	for effect in target.unit.get_effects():
		if cure.has(effect.alias):
			target.unit.effects.remove_child(effect)
