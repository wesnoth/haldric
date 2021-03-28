extends Scenario


func _setup() -> void:
	events.connect("start", self, "start")


func start(scenario):
	var text = [
		"Into the Battle!",
		"...",
		"FOR HALDRIC!!!"
	]

	var leader = scenario.current_side.leaders[0]

	get_tree().call_group("GameUI", "show_message", leader, text)
