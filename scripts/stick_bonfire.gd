extends Node2D


@export var decay_rate: float = 0.1
@export var key_press_rate: float = 0.05
var _completion_amount: float = 0 :
	set(value):
		_completion_amount = min(value, 1.01)
		_completion_amount = max(_completion_amount, 0)


func _process(delta: float) -> void:
	_completion_amount -= decay_rate * delta
	$Control/ColorRect2/Label.text = str(int(_completion_amount * 4))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("key_generic"):
		_completion_amount += key_press_rate
