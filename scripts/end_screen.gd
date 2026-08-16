extends Control

var digit_textures = [
	preload("res://sprites/end/end_levels_0.tres"),
	preload("res://sprites/end/end_levels_1.tres"),
	preload("res://sprites/end/end_levels_2.tres"),
	preload("res://sprites/end/end_levels_3.tres"),
	preload("res://sprites/end/end_levels_4.tres"),
	preload("res://sprites/end/end_levels_5.tres"),
	preload("res://sprites/end/end_levels_6.tres"),
	preload("res://sprites/end/end_levels_7.tres"),
	preload("res://sprites/end/end_levels_8.tres"),
	preload("res://sprites/end/end_levels_9.tres"),
]


func _ready() -> void:
	var score = str(GamestateStorage.passed_levels)
	if GamestateStorage.passed_levels < 10:
		score = "0" + score
	%DigitPos0.texture = digit_textures[int(score[0])]
	%DigitPos1.texture = digit_textures[int(score[1])]
	if(score.length() > 2):
		%DigitPos2.texture = digit_textures[int(score[2])]


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("key_generic"):
		LevelSelector.reset_levels()
		Lives.restore_lives()
		GamestateStorage.reset_state()
		get_tree().change_scene_to_file("res://scenes/transition_screen.tscn")
