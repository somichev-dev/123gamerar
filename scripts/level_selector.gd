extends Node

@export var level_list = [
	"res://scenes/rock_bonfire.tscn",
	"res://scenes/stick_bonfire.tscn",
	"res://scenes/do_nothing.tscn",
	"res://scenes/spell_casting.tscn",
]
@onready var _current_levels = []


func get_next_level() -> String:
	if _current_levels.is_empty():
		reset_levels()
	return _current_levels.pop_at(randi_range(0, _current_levels.size() - 1))


func reset_levels() -> void:
	_current_levels = level_list.duplicate()
	_current_levels.shuffle()
