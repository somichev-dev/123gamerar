extends Node2D

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
@export var transition_time: float = 2
@onready var state_nodes = [
	%SuccessSprite,
	%FailureSprite,
	%SurprisedSprite,
	%FasterSprite
]
var health_textures = [
	preload("res://sprites/health/health_1.tres"),
	preload("res://sprites/health/health_2.tres"),
	preload("res://sprites/health/health_3.tres"),
	preload("res://sprites/health/health_4.tres"),
	preload("res://sprites/health/health_5.tres"),
]

func _ready() -> void:
	%TransitionTimer.start(transition_time)
	_disable_all_states()
	
	if Lives.lives in range(1,6): %HealthTexture.texture = health_textures[Lives.lives-1]
	if (GamestateStorage.check_diff_increase()):
		GamestateStorage.increase_difficulty()
		GamestateStorage.transition_state = GamestateStorage.TransitionScreenState.FASTER
	# score display block
	var score = str(GamestateStorage.passed_levels)
	if GamestateStorage.passed_levels < 10:
		score = "0" + score
	%Digit0.texture = digit_textures[int(score[0])]
	%"Digit1`".texture = digit_textures[int(score[1])]
	if(score.length() > 2):
		%Digit2.texture = digit_textures[int(score[2])]
	
	state_nodes[GamestateStorage.transition_state].visible = true
	match GamestateStorage.transition_state:
		GamestateStorage.TransitionScreenState.SURPRISED:
			BgAudioPlayer.play_level_music(BgAudioPlayer.MusicType.START)
		GamestateStorage.TransitionScreenState.GOOD:
			BgAudioPlayer.play_level_music(BgAudioPlayer.MusicType.SUCCESS)
		GamestateStorage.TransitionScreenState.BAD:
			BgAudioPlayer.play_level_music(BgAudioPlayer.MusicType.FAILURE)
		GamestateStorage.TransitionScreenState.FASTER:
			BgAudioPlayer.play_level_music(BgAudioPlayer.MusicType.SPEEDUP)


func _on_transition_timer_timeout() -> void:
	if Lives.lives == 0:
		BgAudioPlayer.play_level_music(BgAudioPlayer.MusicType.END)
		get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
	else:
		get_tree().change_scene_to_file(LevelSelector.get_next_level())


func _disable_all_states() -> void:
	for n in state_nodes:
		n.visible = false
