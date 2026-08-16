extends AudioStreamPlayer


enum MusicType{
	LEVEL,
	MENU,
	SUCCESS,
	FAILURE
}

var sound_dict = {
	MusicType.LEVEL: preload("res://sounds/gamplay.wav"),
	MusicType.MENU: preload("res://sounds/menu_theme.wav"),
	MusicType.SUCCESS: preload("res://sounds/success.wav"),
	MusicType.FAILURE: preload("res://sounds/failure.wav"),
}

func _enter_tree() -> void:
	stop()

func play_level_music(type: MusicType) -> void:
	stop()
	pitch_scale = 1.0
	if type == MusicType.LEVEL:
		pitch_scale = GamestateStorage.difficulty_scale
	stream = sound_dict[type]
	play()


func _on_finished() -> void:
	print_debug(Time.get_ticks_msec())
