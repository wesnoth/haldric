extends WeaponSpecial
class_name SpecialDamage

export var value := 0
export var multiply := 0
export var add := 0


func _execute(target: CombatContext) -> void:
	if value:
		target.damage = value

	elif multiply:
		target.damage *= multiply

	elif add:
		target.damage += add

	print("damage applied")
