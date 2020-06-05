extends Trait
class_name TraitIntelligent


export var health_modifier := 0.9
export var experience_modifier := 0.8


func _execute(unit: Unit) -> void:
	unit.health.maximum *= health_modifier
	unit.experience.maximum *= experience_modifier

