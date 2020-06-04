extends Node
class_name Attack

enum DamageType { NONE, SLASH, IMPACT, PIERCE, NATURE, BURN, FROST, SHOCK, SONIC, ARCANE, HOLY, CHAOS }

var accuracy := 0

export var alias := ""

export var icon : StreamTexture = null

export var category := "melee"
export var damage_type := ""

export var damage := 0
export var strikes := 0


onready var specials := get_children()


func execute_specials(_self:  CombatContext, opponent:  CombatContext, offender:  CombatContext, defender:  CombatContext) -> void:
	for special in specials:
		special.execute(_self, opponent, offender, defender)


func to_string() -> String:
	var s := "%s: %dx%d (%s) (%s)" % [alias, damage, strikes, category, damage_type]

	for special in specials:
		s += " (%s)" % special.alias

	return s
