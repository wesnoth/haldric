extends Sprite

export (int) var health_max = 30
export (int) var moves_max = 5

var health
var moves

func _ready():
	health = health_max
	moves = moves_max

# P U B L I C   F U N C T I O N S

func restore():
	health = health_max
	moves = moves_max