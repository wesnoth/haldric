extends Node2D
class_name UnitPlate

onready var state_label = $StateLabel as Label
onready var life_bar = $LifeBar

func init(unit):
	unit.connect("state_changed", self, "_on_unit_state_changed")
	unit.connect("health_changed", self, "_on_unit_health_changed")
	unit.connect("hide", self, "_on_unit_hidden")
	unit.connect("unhide", self, "_on_unit_unhidden")
	
	# set initial values
	_on_unit_state_changed(unit.current_state.name)
	_on_unit_health_changed(unit)
	visible = unit.visible
	
func _on_unit_state_changed(new_state):
	state_label.text = new_state

func _on_unit_health_changed(unit):
	life_bar.update_unit(unit)

func _on_unit_hidden():
	visible = false

func _on_unit_unhidden():
	visible = true
