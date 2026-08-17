extends Node2D

@export var required_presses: int = 50
var presses: int = 0
var possible_keys = ["W", "A", "S", "D", "Space"]
@export var timer_amount: float = 5.0
@onready var _current_timer_amount: float = timer_amount

var paintings = [
	preload("res://sprites/graffiti/graffiti_0.tres"),
	preload("res://sprites/graffiti/graffiti_1.tres"),
	preload("res://sprites/graffiti/graffiti_2.tres"),
	preload("res://sprites/graffiti/graffiti_3.tres"),
	preload("res://sprites/graffiti/graffiti_4.tres"),
	preload("res://sprites/graffiti/graffiti_5.tres"),
	preload("res://sprites/graffiti/graffiti_6.tres"),
	preload("res://sprites/graffiti/graffiti_7.tres"),
]

signal finished(has_won: bool)

func _ready() -> void:
	BgAudioPlayer.play_level_music(BgAudioPlayer.MusicType.LEVEL)
	%CharControl/AnimationPlayer.current_animation = "anim_{0}".format([randi()%5])
	%CharControl/AnimationPlayer.play()
	%Painting.texture_progress = paintings.pick_random()
	%Painting.value = 0.0

func _input(event):
	if event.is_action_pressed("key_mash"):
		if randf() < 0.2:
			%CharControl/AnimationPlayer.current_animation = "anim_{0}".format([randi()%5])
		%Painting.value = min(round(100.0 * (float(presses) / required_presses)), 100.0)
		presses += 1
		if presses >= required_presses:
			finished.emit(true)

func _process(delta: float) -> void:
	_current_timer_amount -= delta * GamestateStorage.difficulty_scale
	%CornerTimer.change_anim(int(_current_timer_amount)+1)
	if _current_timer_amount <= 0:
		var has_won = presses >= required_presses
		if not has_won:
			Lives._lose_life()
		GamestateStorage.passed_levels += int(has_won)
		GamestateStorage.transition_state = GamestateStorage.TransitionScreenState.GOOD if has_won else GamestateStorage.TransitionScreenState.BAD
		get_tree().change_scene_to_file("res://scenes/transition_screen.tscn")
