extends Panel

var Game = preload("res://game/Game.tscn")

onready var start_game_button = $"VBoxContainer/StartGame"
onready var quit_button = $"VBoxContainer/Quit"

func _ready():
	Registry.load_ability_dir("res://configs/abilities")
	Registry.load_unit_dir("res://configs/units")
	Registry.validate_advancements()
	
	Registry.load_scenario_dir("res://configs/scenarios")
	
	start_game_button.connect("pressed", self, "_on_start_game_button_pressed")
	quit_button.connect("pressed", self, "_on_quit_button_pressed")


func _on_start_game_button_pressed():
	var game = Game.instance()
	get_tree().get_root().add_child(game)
	game.initialize(Registry.scenarios["sample_map"])
	hide()

func _on_quit_button_pressed():
	get_tree().quit()