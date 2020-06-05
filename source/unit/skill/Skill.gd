extends Node
class_name Skill

enum Target { ENEMY, ALLY, LOCATION }

var cooldown := 0
var count := 0

export var alias := ""
export(String, MULTILINE) var description := ""

export(Target) var target = Target.ENEMY

export var reach := 1
export var _count := 0
export var _cooldown := 1


func _ready() -> void:
	cooldown = _cooldown


func execute(target: Location) -> void:
	use()
	_execute(target)


func use() -> void:
	count = clamp(count - 1, 0, _count)

	if not count:
		cooldown = _cooldown


func tick() -> void:
	cooldown = clamp(cooldown - 1, 0, _cooldown)

	if cooldown == 0:
		count = _count


func reset_cooldown() -> void:
	cooldown = 0


func is_usable() -> bool:
	return cooldown == 0


func to_string() -> String:
	var s = ""

	if count > 1:
		s += "%dx " % count

	s += alias

	if not is_usable():
		s += " (%d)" % cooldown

	s += "\n%s" % description
	return s


func to_preview_string() -> String:
	var s = ""
	s += "%dx " % _count
	s += alias
	s += " (%d)" % _cooldown
	s += "\n%s" % description
	return s


#virtual
func _execute(target: Location) -> void:
	pass
