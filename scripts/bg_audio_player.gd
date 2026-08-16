extends AudioStreamPlayer


enum MusicType{
	LEVEL,
	MENU,
	START,
	SUCCESS,
	FAILURE,
	END,
	SPEEDUP
}

var sound_dict = {
	MusicType.LEVEL: preload("res://sounds/gamplay.wav"),
	MusicType.MENU: preload("res://sounds/menu_theme.wav"),
	MusicType.SUCCESS: preload("res://sounds/success.wav"),
	MusicType.FAILURE: preload("res://sounds/failure.wav"),
	MusicType.START: preload("res://sounds/start.wav"),
	MusicType.END: preload("res://sounds/end.wav"),
	MusicType.SPEEDUP: preload("res://sounds/speedup.wav"),
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
