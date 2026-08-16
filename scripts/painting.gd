extends Node2D

@export var required_presses: int = 40
var presses: int = 0
var possible_keys = ["W", "A", "S", "D", "Space"]
@export var timer_amount: float = 5.0
@onready var _current_timer_amount: float = timer_amount

var paintings = [
	preload("res://sprites/paintings/painting_1.tres"),
	preload("res://sprites/paintings/painting_2.tres"),
	preload("res://sprites/paintings/painting_3.tres")
]

signal finished(has_won: bool)

func _ready() -> void:
	BgAudioPlayer.play_level_music(BgAudioPlayer.MusicType.LEVEL)
	%painting.texture = paintings.pick_random()
	%painting.self_modulate.a = 0.0

func _input(event):
	if event.is_action_pressed("key_mash"):
		presses += 1
		%painting.self_modulate.a = float(presses) / required_presses
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
