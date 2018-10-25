extends Resource


const income_per_village = 2

const heal_on_village = 8
const heal_on_rest = 2

var base_income = 2

var team_color

var side = 0

var gold = 100
var income = 2

var recruit = []

var villages = []

var leaders = []

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

func calculate_income():
	income = income_per_village * villages.size() + base_income

func turn_refresh():
	gold += income

func get_first_leader():
	if leaders.size() > 0:
		return leaders[0]
	return null