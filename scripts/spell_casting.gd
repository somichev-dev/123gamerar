extends Node2D

@export var timer_amount: float = 5.0
@export var amount = int(5 * GamestateStorage.difficulty_scale)
var possible_keys = ["W", "A", "S", "D"]
var sequence = []

var key_textures = {
	"W": preload("res://sprites/keys/key_hint_w.tres"),
	"A": preload("res://sprites/keys/key_hint_a.tres"),
	"S": preload("res://sprites/keys/key_hint_s.tres"),
	"D": preload("res://sprites/keys/key_hint_d.tres")
}

@onready var _current_timer_amount: float = timer_amount

func _ready() -> void:
	BgAudioPlayer.play_level_music(BgAudioPlayer.MusicType.LEVEL)
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
	if event is InputEventKey and event.pressed:
		var pressed_key = event.as_text()
		if pressed_key not in possible_keys:
			return
		if pressed_key != sequence[current_index]:
			finished.emit(false)
			return
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
