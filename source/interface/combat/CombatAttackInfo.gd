extends MarginContainer
class_name CombatAttackInfo

onready var name_label := $HBoxContainer/VBoxContainer/Name
onready var damage_label := $HBoxContainer/VBoxContainer4/Damage
onready var accuracy_label := $HBoxContainer/VBoxContainer4/Accuracy
onready var type_label := $HBoxContainer/VBoxContainer3/Type
onready var specials_label := $HBoxContainer/VBoxContainer3/Specials


func update_info(unit: CombatContext, opponent: CombatContext) -> void:
	clear()
	if not unit.has_attack():
		return

	name_label.text = unit.alias
	type_label.text = "(%s)" % unit.damage_type
	accuracy_label.text = "%d %%" % unit.accuracy

	var damage = opponent.unit.calculate_damage(unit.damage, unit.damage_type)

	damage_label.text = "%d x %d" % [damage, unit.strikes]

	for special in unit.get_specials():
		specials_label.text += "(%s) " % special.alias


func clear() -> void:
	name_label.text = "None"
	damage_label.text = "0 x 0"
	type_label.text = "(none)"
	accuracy_label.text = "0 %"
	specials_label.text = ""
