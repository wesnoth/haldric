extends HBoxContainer

var Attack = preload("res://source/interface/panel/AttackItem.tscn")

onready var border_left = $"../AttacksBorderLeft"
onready var border_right = $"../AttacksBorderRight"

func update_attack_info(attacks):
	remove_attacks()
	
	for attack in attacks:
		add_attack(attack)
	
	if attacks.size() > 0:
		border_left.show()
		border_right.show()
	
	print(get_child_count())
	
	show()

func clear_attack_info():
	hide()
	remove_attacks()

func add_attack(attack):
	var item = Attack.instance()
	add_child(item)
	item.initialize(attack)

func remove_attacks():
	for child in get_children():
		child.free()
	border_left.hide()
	border_right.hide()