extends Trait
class_name TraitUpkeep

export(Unit.UpkeepType) var upkeep := Unit.UpkeepType.LOYAL


func _execute(unit: Unit) -> void:
	unit.upkeep = upkeep
