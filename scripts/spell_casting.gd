extends Node2D

@export var timer_amount: float = 5.0
@export var amount = 5
var modulation_colors = [Color("555555"), Color("FFFFFF")]
var input_threshold = 5.0
var possible_keys = ["key_left", "key_right", "key_down", "key_up"]
var sequence = []

var target_vectors = {
	"key_up": Vector2(0, 1),
	"key_left": Vector2(-1, 0),
	"key_down": Vector2(0, -1),
	"key_right": Vector2(1, 0),
}

var sprite_mapper = {
	"key_up": "up",
	"key_left": "left",
	"key_down": "down",
	"key_right":"right",
}

@onready var _current_timer_amount: float = timer_amount
@onready var sequence_nodes = [
	$Control/Sequence0, $Control/Sequence1, $Control/Sequence2, $Control/Sequence3, $Control/Sequence4
]

func _ready() -> void:
	$Control/Sequence0/AnimationPlayer.pause()
	$Control/Sequence1/AnimationPlayer.pause()
	$Control/Sequence2/AnimationPlayer.pause()
	$Control/Sequence3/AnimationPlayer.pause()
	$Control/Sequence4/AnimationPlayer.pause()
	
	BgAudioPlayer.play_level_music(BgAudioPlayer.MusicType.LEVEL)
	finished.connect(_minigame_finished)
	for i in amount: sequence.append(possible_keys.pick_random())
	$Control/Sequence0/TextureRect.texture = load("res://sprites/arrows/arrow_{0}_0.tres".format([sprite_mapper[sequence[0]]]))
	$Control/Sequence1/TextureRect.texture = load("res://sprites/arrows/arrow_{0}_1.tres".format([sprite_mapper[sequence[1]]]))
	$Control/Sequence2/TextureRect.texture = load("res://sprites/arrows/arrow_{0}_2.tres".format([sprite_mapper[sequence[2]]]))
	$Control/Sequence3/TextureRect.texture = load("res://sprites/arrows/arrow_{0}_3.tres".format([sprite_mapper[sequence[3]]]))
	$Control/Sequence4/TextureRect.texture = load("res://sprites/arrows/arrow_{0}_4.tres".format([sprite_mapper[sequence[4]]]))

var current_index: int = 0

signal finished(has_won: bool)

func _input(event):
	## это отвратительный код для поимки actions
	var input_matrix = {
		"key_up": int(event.is_action_pressed("key_up")),
		"key_left": int(event.is_action_pressed("key_left")),
		"key_down": int(event.is_action_pressed("key_down")),
		"key_right": int(event.is_action_pressed("key_right")),
	}
	var reducent = input_matrix["key_up"] + input_matrix["key_down"] + input_matrix["key_left"] + input_matrix["key_right"]
	if reducent == 0: return
	var is_right_action_pressed = (input_matrix[sequence[current_index]]) and reducent < 3
	if !is_right_action_pressed:
		finished.emit(false)
	else:
		sequence_nodes[current_index].modulate = modulation_colors[0]
		current_index += 1
		if current_index == sequence.size():
			finished.emit(true)


func _process(delta: float) -> void:
	_current_timer_amount -= delta * GamestateStorage.difficulty_scale

	%CornerTimer.change_anim(int(_current_timer_amount)+1)
	if _current_timer_amount <= 0:
		finished.emit(false)
		
func _minigame_finished(has_won):
	if not has_won:
		Lives._lose_life()
	GamestateStorage.passed_levels += int(has_won)
	GamestateStorage.transition_state = GamestateStorage.TransitionScreenState.GOOD if has_won else GamestateStorage.TransitionScreenState.BAD
	get_tree().change_scene_to_file("res://scenes/transition_screen.tscn")


func _on_timer0_timeout() -> void:
	$Control/Sequence0/AnimationPlayer.play("swing")


func _on_timer1_timeout() -> void:
	$Control/Sequence1/AnimationPlayer.play("swing")


func _on_timer2_timeout() -> void:
	$Control/Sequence2/AnimationPlayer.play("swing")


func _on_timer3_timeout() -> void:
	$Control/Sequence3/AnimationPlayer.play("swing")


func _on_timer4_timeout() -> void:
	$Control/Sequence4/AnimationPlayer.play("swing")
