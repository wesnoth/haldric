extends Control

func _ready():
	var data = Loader.load_dir("res://data/test_files")
	for file in data:
		print(file.text)