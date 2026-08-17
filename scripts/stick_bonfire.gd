extends Node2D

@export var anim_points = [
	Vector2(0, 0),
	Vector2(0, 0)
]
@export var decay_rate: float = 0.1
@export var key_press_rate: float = 0.05
@export var timer_amount: float = 5.0
@export var win_threshold: float = 0.9

@onready var _current_timer_amount: float = timer_amount

@onready var _dirt_nodes = [
	%BobbyDirt0, %BobbyDirt1, %BobbyDirt2, %BobbyDirt3, %BobbyDirt4, %BobbyDirt5
]
var has_won: bool = false
var _stick_position: bool = false ## used to switch between frames for stick/hands
var modulation_colors = [Color("555555"), Color("FFFFFF")]
var _completion_amount: float = 0 :
	set(value):
		_completion_amount = min(value, 1.1)
		_completion_amount = max(_completion_amount, 0)


func _ready() -> void:
	BgAudioPlayer.play_level_music(BgAudioPlayer.MusicType.LEVEL)


func _process(delta: float) -> void:
	%ButtonHintLeft.modulate = modulation_colors[int(!_stick_position)]
	%ButtonHintRight.modulate = modulation_colors[int(_stick_position)]
	for i in _dirt_nodes.size():
		get_node("%BobbyDirt{0}".format([i])).visible = !(_completion_amount > (win_threshold / _dirt_nodes.size() * (i+1)))
	has_won = (_completion_amount >= win_threshold)
	if has_won:
		%Bobby.texture = load("res://sprites/bobby/bobby_0.tres")
		%BobbyBrush.visible = false
		%BobbyClean.visible = true
	_current_timer_amount -= delta * GamestateStorage.difficulty_scale
	%CornerTimer.change_anim(int(_current_timer_amount)+1)
	if _current_timer_amount <= 0:
		if not has_won:
			Lives._lose_life()
		GamestateStorage.passed_levels += int(has_won)
		GamestateStorage.transition_state = GamestateStorage.TransitionScreenState.GOOD if has_won else GamestateStorage.TransitionScreenState.BAD
		get_tree().change_scene_to_file("res://scenes/transition_screen.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if has_won: return
	if event.is_action_pressed("key_left") and !_stick_position:
		%BobbyBrush.position = anim_points[1]
		_completion_amount += key_press_rate
		_stick_position = !_stick_position
	if event.is_action_pressed("key_right") and _stick_position:
		%BobbyBrush.position = anim_points[0]
		_completion_amount += key_press_rate
		_stick_position = !_stick_position
