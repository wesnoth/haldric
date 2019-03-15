extends Node2D

onready var player = $AudioStreamPlayer

func play(track : AudioStream) -> void:
	player.stream = track
	player.play()