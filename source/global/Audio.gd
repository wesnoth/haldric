extends Node2D

onready var player = $AudioStreamPlayer

func play(track : AudioStream) -> void:
	if player.stream == track:
		return
	
	player.stream = track
	player.play()