extends Effect
class_name EffectAttribute

export(String, "health", "moves", "experience", "actions") var attribute := "health"

export var value := 0
export var add := 0
export var multiply := 0.0


func _execute(unit) -> void:
	var _attribute = unit.get(attribute)

	if value:
		_attribute.maximum = value

	elif add:
		_attribute.maximum += add

	elif multiply:
		_attribute.maximum *= multiply


