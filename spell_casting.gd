extends Node2D

@export var timer_amount: float = 5.0
@export var amount = int(5 * GamestateStorage.difficulty_scale)
var modulation_colors = [Color("555555"), Color("FFFFFF")]
var input_threshold = 5.0
var possible_keys = ["key_left", "key_right", "key_down", "key_up"]
var sequence = []

var key_textures = {
	"key_up": preload("res://sprites/keys/key_hint_w.tres"),
	"key_left": preload("res://sprites/keys/key_hint_a.tres"),
	"key_down": preload("res://sprites/keys/key_hint_s.tres"),
	"key_right": preload("res://sprites/keys/key_hint_d.tres")
}
var target_vectors = {
	"key_up": Vector2(0, 1),
	"key_left": Vector2(-1, 0),
	"key_down": Vector2(0, -1),
	"key_right": Vector2(1, 0),
}

@onready var _current_timer_amount: float = timer_amount

func _ready() -> void:
	finished.connect(_minigame_finished)
	for i in amount: sequence.append(possible_keys.pick_random())
	for key in sequence:
		var icon = TextureRect.new()
		icon.texture = key_textures[key]
		icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		icon.size = icon.texture.get_size()
		%SequenceContainer.add_child(icon)

var current_index: int = 0

signal finished(has_won: bool)

func _input(event):
	## это отвратительный код для поимки actions
	var input_vector = Input.get_vector("key_left", "key_right", "key_down", "key_up").normalized()
	if input_vector.length_squared() < 0.1: return
	var target_vector = target_vectors[sequence[current_index]]
	var dot = input_vector.dot(target_vector)
	var is_right_action_pressed = dot >= cos(deg_to_rad(input_threshold))
	
	if !is_right_action_pressed:
		finished.emit(false)
		return
	%SequenceContainer.get_child(current_index).modulate = modulation_colors[0]
	current_index += 1
	if current_index == sequence.size():
		finished.emit(true)


func _process(delta: float) -> void:
	_current_timer_amount -= delta

	%CornerTimer.change_anim(int(_current_timer_amount)+1)
	if _current_timer_amount <= 0:
		finished.emit(false)
		
func _minigame_finished(has_won):
	if not has_won:
		Lives._lose_life()
	GamestateStorage.passed_levels += int(has_won)
	GamestateStorage.transition_state = GamestateStorage.TransitionScreenState.GOOD if has_won else GamestateStorage.TransitionScreenState.BAD
	get_tree().change_scene_to_file("res://scenes/transition_screen.tscn")
