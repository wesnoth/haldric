extends Advancement
class_name UnitTypeAdvancement

export(PackedScene) var type : PackedScene = null

func execute(unit) -> void:
	var unit_type = type.instance() as UnitType

	if unit_type:
		unit.set_type(unit_type)
	.execute(unit)
