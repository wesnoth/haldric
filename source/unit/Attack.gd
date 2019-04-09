extends Node
class_name Attack

export var id := ""
export(String, "ranged", "melee") var reach := ""
export(String, "blade", "pierce", "impact", "fire", "cold", "arcane") var type := ""
export var damage := 0
export var strikes := 0
export var icon : StreamTexture = null

onready var specials := get_children()