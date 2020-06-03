extends Ability
class_name AbilityHeal

export var amount := 4
export(String, "slowed", "cured") var cure := "slowed"

func _execute(target: Location) -> void:
	target.unit.heal(amount, true)
