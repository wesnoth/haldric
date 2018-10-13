extends Panel

onready var start_game_button = $"VBoxContainer/StartGame"
onready var quit_button = $"VBoxContainer/Quit"

func _ready():
	start_game_button.connect("pressed", self, "_on_start_game_button_pressed")
	quit_button.connect("pressed", self, "_on_quit_button_pressed")


func _on_start_game_button_pressed():
	get_tree().change_scene("res://game/Game.tscn")

func _on_quit_button_pressed():
	get_tree().quit()