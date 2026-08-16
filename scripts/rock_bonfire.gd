extends Node2D


@export var decay_rate: float = 0.1
@export var key_press_rate: float = 0.05
@export var timer_amount: float = 5.0
@export var win_threshold: float = 0.9

@onready var _current_timer_amount: float = timer_amount
var _rock_position: bool = false ## used to switch between frames for rocks
var _completion_amount: float = 0 :
	set(value):
		_completion_amount = min(value, 1.1)
		_completion_amount = max(_completion_amount, 0)

var modulation_colors = [Color("555555"), Color("FFFFFF")]
@export var rock_positions = [Vector2(199.0, 5.0), Vector2(199.0, 54.0)]
var sparks_scene = preload("res://scenes/sparks.tscn")


func _process(delta: float) -> void:
	_completion_amount -= decay_rate * delta
	$Control/ColorRect2/Label.text = str(int(_completion_amount * 4))
	
	## win/transition block
	_current_timer_amount -= delta
	%CornerTimer.change_anim(int(_current_timer_amount)+1)
	if _current_timer_amount <= 0:
		var has_won = _completion_amount >= win_threshold
		if not has_won:
			Lives._lose_life()
		GamestateStorage.passed_levels += int(has_won)
		GamestateStorage.transition_state = GamestateStorage.TransitionScreenState.GOOD if has_won else GamestateStorage.TransitionScreenState.BAD
		get_tree().change_scene_to_file("res://scenes/transition_screen.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("key_generic"):
		_rock_position = true
		_completion_amount += key_press_rate
		%KeyHint.modulate = modulation_colors[0]
		%RockUpper.position = rock_positions[1]
		var sparksInstance = sparks_scene.instantiate()
		sparksInstance.emitting = true
		%SparksPoint.add_child(sparksInstance)
		%BangingSoundPlayer.play()
		return
	if event.is_action_released("key_generic"):
		_rock_position = false
		%KeyHint.modulate = modulation_colors[1]
		%RockUpper.position = rock_positions[0]
		return
