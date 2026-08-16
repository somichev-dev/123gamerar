extends Node

@export var max_lives: int = 3
var lives: int
signal lives_over

func _ready() -> void:
	lives = max_lives


func _lose_life():
	if lives > 0: lives -= 1
	if lives == 0: emit_signal("lives_over")


func _restore_lives():
	lives = max_lives
