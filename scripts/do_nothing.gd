extends Node2D

@export var timer_amount: float = 5.0
@onready var _current_timer_amount: float = timer_amount

func _ready() -> void:
	BgAudioPlayer.play_level_music(BgAudioPlayer.MusicType.LEVEL)
	%Explode.visible = false
	%Explode.frame = 0

func _input(event): #сом сам разберёшся как это в геймпад превратить
	if event is InputEventKey and event.pressed:
		get_tree().paused = true
		%Explode.visible = true
		%Explode.play()
		await %Explode.animation_finished
		%Explode.visible = false
		get_tree().paused = false
		Lives._lose_life()
		var has_won = false
		GamestateStorage.transition_state = GamestateStorage.TransitionScreenState.BAD
		get_tree().change_scene_to_file("res://scenes/transition_screen.tscn")

func _process(delta: float) -> void:
	_current_timer_amount -= delta
	%CornerTimer.change_anim(int(_current_timer_amount)+1)
	if _current_timer_amount <= 0:
		var has_won = true
		GamestateStorage.passed_levels += int(has_won)
		GamestateStorage.transition_state = GamestateStorage.TransitionScreenState.GOOD
		get_tree().change_scene_to_file("res://scenes/transition_screen.tscn")
