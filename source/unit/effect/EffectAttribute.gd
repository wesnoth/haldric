extends Effect
class_name EffectAttribute

export(String, "health", "moves", "experience", "actions") var attribute := "health"

export var value := 0
export var add := 0
export var multiply := 0.0


func _execute(unit) -> void:
	var _attribute = unit.type.get(attribute)

	if value:
		unit.type.set(attribute, value)

	elif add:
		unit.type.set(attribute, _attribute + add)

	elif multiply:
		unit.type.set(attribute, _attribute * multiply)


