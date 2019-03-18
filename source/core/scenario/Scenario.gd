class_name Scenario extends Node2D

export(String) var title = ""
export(int) var turns = 99
export(int) var side_number = 2

onready var map = $Map
onready var units = $Units
onready var sides = $Sides

func initialize() -> void:
	TeamColor.initializeFlagColors()
	for i in range(sides):
		var side := Side.new()
		side.initialize(i)
		side.team_color = TeamColor.team_color_data.keys()[i]
		side.team_color_info = TeamColor.team_color_data[side.team_color]
		side.shader = TeamColor.generate_team_shader(side.team_color_info)
		side.shader = TeamColor.generate_team_shader(side.team_color_info)
		sides.add_child(side)

func add_unit(unit : Unit, cell : Vector2, side_number : int) -> void:
	var side : Side = sides.get_child(side_number-1)
	side.add_child(unit)
	var loc = map.get_location(cell)
	unit.move_to(loc)
	unit.sprite.set_material(side.shader)
