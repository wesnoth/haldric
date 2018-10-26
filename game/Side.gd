extends Resource

var side

var gold
var income

var villages
var color

var shader
var heal_on_village = 8
var heal_on_rest = 2

func initialize(side, color = "red", gold = 100, income = 2, starting_villages = []):
	self.side = side
	self.gold = gold
	self.income = income
	self.villages = starting_villages
	self.color = color

func add_village(cell):
	villages.append(cell)

func get_villages():
	return villages

