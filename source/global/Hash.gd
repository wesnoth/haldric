extends Node

var rand := {}

func initialize(width: int, height: int) -> void:
	rand.clear()
	rand_seed(0)

	for y in height:
		for x in width:
			rand[Vector2(x, y)] = {
				"ai": randi(),
				"bi": randi(),
				"ci": randi(),
				"di": randi(),
				"ei": randi(),
				"fi": randi(),

				"af": randf(),
				"bf": randf(),
				"cf": randf(),
				"df": randf(),
				"ef": randf(),
				"ff": randf(),
			}
