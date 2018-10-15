extends Node2D

onready var progress_bar = $"TextureProgress"

func set_max_value(max_value):
	progress_bar.max_value = max_value

func set_value(value):
	progress_bar.value = value