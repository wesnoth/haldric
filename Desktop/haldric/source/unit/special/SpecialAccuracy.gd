extends WeaponSpecial
class_name SpecialAccuracy

export var accuracy = 0


func _execute(target: CombatContext) -> void:
	target.accuracy = accuracy
	print("accuracy applied")
