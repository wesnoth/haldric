extends Node

onready var music_player := $MusicPlayer as AudioStreamPlayer
onready var effects_player := $EffectsPlayer as AudioStreamPlayer
onready var interface_player := $InterfacePlayer as AudioStreamPlayer

func play_music(track: AudioStream) -> void:
	_play(music_player, track)

func play_effect(track: AudioStream) -> void:
	_play(effects_player, track)

func play_interface(track: AudioStream) -> void:
	_play(interface_player, track)

func _play(player: AudioStreamPlayer, track: AudioStream) -> void:
	if player.stream == track:
		return
	player.stream = track
	player.play()
