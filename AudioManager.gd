extends Node

var level_music = preload("res://sounds/gamplay.wav")

func play_level_music() -> void:
	var music_player = new AudioStreamPlayer()
	add_child(music_player)
	music_player.stream = level_music
	music_player.play()
