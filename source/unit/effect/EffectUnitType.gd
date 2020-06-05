extends Effect
class_name EffectUnitType

export(PackedScene) var type : PackedScene = null


func _execute(unit) -> void:
	var unit_type := type.instance() as UnitType

	if unit_type:
		unit.set_type(unit_type)
