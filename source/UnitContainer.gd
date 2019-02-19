extends Node

var table = {}

func add(unit):
	table[unit.numerical_id] = unit
	add_child(unit)

func get(id):
	if table.has(id):
		return table[id]
	return null

func remove(id):
	if table.has(id):
		var unit = table[id]
		table.erase(id)
		unit.queue_free()