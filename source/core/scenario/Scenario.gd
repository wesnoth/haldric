class_name Scenario extends Node2D

export(String) var title = ""
export(int) var turns = 99
export(int) var side_number = 2

onready var map = $Map
onready var units = $Units
onready var sides = $Sides

func initialize() -> void:
	TeamColor.initializeFlagColors()
	for i in range(side_number):
		var side := Side.new()
		side.initialize(i)
		side.team_color = TeamColor.team_color_data.keys()[i]
		side.team_color_info = TeamColor.team_color_data[side.team_color]
		side.shader = TeamColor.generate_team_shader(side.team_color_info)
		side.shader = TeamColor.generate_team_shader(side.team_color_info)
		sides.add_child(side)

func add_unit(side_number : int, unit_id : String, x : int, y : int) -> void:
	var side : Side = sides.get_child(side_number-1)
	var unit = Wesnoth.Unit.instance()
	
	side.add_child(unit)
	unit.initialize(Registry.units[unit_id])
	
	var loc = map.get_location(Vector2(x, y))
	unit.place_at(loc)
	
	unit.sprite.set_material(side.shader)
