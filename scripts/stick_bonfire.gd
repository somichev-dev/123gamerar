extends Node2D


@export var decay_rate: float = 0.1
@export var key_press_rate: float = 0.05
@export var timer_amount: float = 5.0
@export var win_threshold: float = 0.9

@onready var _current_timer_amount: float = timer_amount
var _stick_position: bool = false ## used to switch between frames for stick/hands
var modulation_colors = [Color("555555"), Color("FFFFFF")]
var _completion_amount: float = 0 :
	set(value):
		_completion_amount = min(value, 1.1)
		_completion_amount = max(_completion_amount, 0)


func _process(delta: float) -> void:
	_completion_amount -= decay_rate * delta
	$Control/ColorRect2/Label.text = str(int(_completion_amount * 4))
	$Control/TextureRectLeft.modulate = modulation_colors[int(!_stick_position)]
	$Control/TextureRectRight.modulate = modulation_colors[int(_stick_position)]
	
	## win/transition block
	_current_timer_amount -= delta
	%CornerTimer.change_anim(int(_current_timer_amount)+1)
	if _current_timer_amount <= 0:
		var has_won: bool = (_completion_amount >= win_threshold)
		if not has_won:
			Lives._lose_life()
		GamestateStorage.passed_levels += int(has_won)
		GamestateStorage.transition_state = GamestateStorage.TransitionScreenState.GOOD if has_won else GamestateStorage.TransitionScreenState.BAD
		get_tree().change_scene_to_file("res://scenes/transition_screen.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("key_left") and !_stick_position:
		_completion_amount += key_press_rate
		_stick_position = !_stick_position
	if event.is_action_pressed("key_right") and _stick_position:
		_completion_amount += key_press_rate
		_stick_position = !_stick_position
