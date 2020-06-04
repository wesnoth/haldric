extends Trait
class_name TraitQuick

export var health_modifier := 0.95
export var bonus_moves := 1

func _execute(unit: Unit) -> void:
	unit.health.maximum *= health_modifier
	unit.moves.maximum += bonus_moves
