class_name Side extends Node2D


const income_per_village : int = 2

const heal_on_village : int = 8
const heal_on_rest : int = 2

var base_income : int = 2

var team_color : String
var team_color_info : Array
var side : int = 0

var gold : int = 100
var income : int = 2

var shader : ShaderMaterial = null
var flag_shader : ShaderMaterial = null

var recruit : Array = []

var villages : Array = []

var leaders : Array = []

var units : Array = []

func initialize(side, gold = 100, base_income = 2, starting_villages = []):
	self.base_income = base_income
	self.side = side
	self.gold = gold
	self.villages = starting_villages
	calculate_income()

func add_village(cell):
	villages.append(cell)

func remove_village(cell):
	villages.erase(cell)

func has_village(cell):
	return villages.has(cell)

func get_villages():
	return villages
s
func calculate_income():
	income = income_per_village * villages.size() + base_income

func turn_refresh():
	gold += income

func get_first_leader():
	if leaders.size() > 0:
		return leaders[0]
	return null
