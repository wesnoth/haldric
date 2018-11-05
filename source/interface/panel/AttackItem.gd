extends Control

var resistance_icons = {
	blank = preload("res://images/icons/resistance/blank.png"),
	blade = preload("res://images/icons/resistance/blade.png"),
	pierce = preload("res://images/icons/resistance/pierce.png"),
	impact = preload("res://images/icons/resistance/impact.png"),
	cold = preload("res://images/icons/resistance/cold.png"),
	fire = preload("res://images/icons/resistance/fire.png"),
	arcane = preload("res://images/icons/resistance/arcane.png")
}

onready var attack_icon = $"Icon"
onready var type_icon = $"Type"
onready var range_icon = $"Range"
onready var label = $"Label"

func initialize(attack_info):
	attack_icon.texture = load(attack_info.icon)
	if resistance_icons.has(attack_info.type):
		type_icon.texture = resistance_icons[attack_info.type]
	else:
		type_icon.texture = resistance_icons["blank"]
	range_icon.texture = resistance_icons["blank"]
	label.text = str(attack_info.damage, " x ", attack_info.strikes)