extends Node

onready var player := $AudioStreamPlayer as AudioStreamPlayer

func play(track: AudioStream) -> void:
	if player.stream == track:
		return
	
	player.stream = track
	player.play()
