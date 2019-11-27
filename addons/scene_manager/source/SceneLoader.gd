extends Node
class_name SceneLoader

signal scene_loaded(scene)
signal stage_changed(stage)

var loader: ResourceInteractiveLoader = null

var current_stage := -1

func _process(delta) -> void:

	if loader == null:
		return

	match loader.poll():
		OK:
			var stage = loader.get_stage()
			if stage != current_stage:
				current_stage = stage
				emit_signal("stage_changed", current_stage)
		ERR_FILE_EOF:
			emit_signal("scene_loaded", loader.get_resource())
			loader = null

func load_interactive(scene: String) -> void:
	loader = ResourceLoader.load_interactive(scene)

func get_stage_count() -> int:
	if not loader:
		return 0
	return loader.get_stage_count() - 1
