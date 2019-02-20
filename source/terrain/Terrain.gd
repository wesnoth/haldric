class_name Terrain extends Resource

var code := []
var type := []

var name := ""

var recruit_onto := false
var recruit_from := false

var gives_income := false
var heals := false

var submerge := false

func _init(cfgs : Array) -> void:
	for cfg in cfgs:
		name = cfg.name
		
		code.append(cfg.code)
		type.append(cfg.type)
		
		if cfg.has("recruit_onto"):
			recruit_onto = cfg.recruit_onto
		
		if cfg.has("recruit_from"):
			recruit_from = cfg.recruit_from
		
		if cfg.has("gives_income"):
			gives_income = cfg.gives_income
		
		if cfg.has("heals"):
			heals = cfg.heals
		
		if cfg.has("submerge"):
			submerge = cfg.submerge

func get_code() -> String:
	var s := ""
	for c in code:
		s += c
	return s

func get_type() -> String:
	var s := "("
	for i in range(type.size()):
		if i == 0:
			s += type[i]
		else:
			s += ", " + type[i]
	s += ")"
	return s