extends Resource
class_name Race

export var id := ""

export var male_singular := ""
export var female_singular := ""
export var singular := ""

export var plural := ""

export(String, MULTILINE) var description := ""

export(String, MULTILINE) var male_names := ""
export(String, MULTILINE) var female_names := ""

export var trait_count := 2

export(Array, PackedScene) var traits := []


func get_random_name() -> String:
	randomize()
	var list = male_names.split(",")
	var name : String = list[randi() % list.size()]
	return name.strip_edges()


func get_random_traits() -> Array:
	var a := []

	while a.size() < trait_count and a.size() < traits.size():
		var trait = traits[randi() % traits.size()]
		if not a.has(trait):
			a.append(trait)

	return a
