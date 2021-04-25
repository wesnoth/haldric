extends Advancement
class_name DefaultAdvancement

func execute(unit) -> void:
	unit.health.maximum += 3
	unit.experience.maximum *= 1.2
	.execute(unit)
