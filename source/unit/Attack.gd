extends Node
class_name Attack

export var icon : StreamTexture = null

export var id := ""
export var type := ""
export var reach := ""
export var damage := 0
export var strikes := 0

onready var specials := get_children()