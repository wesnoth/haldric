class_name Side extends Node2D

const income_per_village := 2

const heal_on_village := 8
const heal_on_rest := 2

var base_income := 2

var team_color := ""
var team_color_info := []
var side := 0

var gold := 100
var income := 2

var shader : ShaderMaterial = null
var flag_shader : ShaderMaterial = null

var recruit := []

var villages := []

var leaders := []

var units := []

func initialize(side : int, gold := 100, base_income := 2, starting_villages := []) -> void:
	self.base_income = base_income
	self.side = side
	self.gold = gold
	self.villages = starting_villages
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
