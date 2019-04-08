extends Resource
class_name Terrain

var layer := 0
var code := []
var type := []

var name := ""

var recruit_onto := false
var recruit_from := false

var gives_income := false
var heals := false

var submerge := false

var time_of_day : DayTime = null

func _init(resources: Array) -> void:
	for res in resources:
		name = res.name

		layer = res.layer

		code.append(res.code)
		type.append(res.type)

		recruit_onto = res.recruit_onto
		recruit_from = res.recruit_from
		gives_income = res.gives_income
		heals = res.heals
		submerge = res.submerge

func set_time_of_day(daytime: DayTime)-> void:
	time_of_day = daytime

func get_base_code():
	return code[0]

func get_overlay_code():
	if code.size() == 2:
		return code[1]
	return ""

func get_code() -> String:
	var s := ""
	for c in code:
		s += c

	return s

func get_type() -> String:
	var s := "("
	for i in type.size():
		if i == 0:
			s += type[i]
		else:
			s += ", " + type[i]
	s += ")"

	return s
