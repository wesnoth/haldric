class_name Side extends Node

const income_per_village := 2

const heal_on_village := 8
const heal_on_rest := 2

var side := 0

export(int) var base_income = 2

export(String) var team_color = ""
var team_color_info := []

export(int) var gold = 100
export(int) var income = 2

var shader : ShaderMaterial = null
var flag_shader : ShaderMaterial = null

var recruit := []

var villages := []

var leaders := []

var units := []

func _ready() -> void:
	side = get_index()

	team_color = TeamColor.team_color_data.keys()[side]
	team_color_info = TeamColor.team_color_data[team_color]
	shader = TeamColor.generate_team_shader(team_color_info)

	calculate_income()

func add_village(cell : Vector2) -> void:
	villages.append(cell)

func remove_village(cell : Vector2) -> void:
	villages.erase(cell)

func has_village(cell : Vector2) -> bool:
	return villages.has(cell)

func get_villages() -> Array:
	return villages

func calculate_income() -> void:
	income = income_per_village * villages.size() + base_income

func turn_refresh() -> void:
	gold += income

func get_first_leader() -> Unit:
	if leaders.size() > 0:
		return leaders[0]
	return null
