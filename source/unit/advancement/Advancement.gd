extends Node
class_name Advancement

export var alias := ""
export(String, MULTILINE) var description := ""

export var image : Texture = null

export var max_times := 1

export var restore_unit := true

export var is_major := false
export var is_strict := false

export var force_display := false

export(Array, NodePath) var require := []
export(Array, NodePath) var exclude := []


func execute(unit) -> void:
	for effect in get_children():
		effect.execute(unit)
	if restore_unit:
		unit.reset()
