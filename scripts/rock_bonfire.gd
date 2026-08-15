extends Node2D


@export var decay_rate: float = 0.1
@export var key_press_rate: float = 0.05
var _rock_position: bool = false ## used to switch between frames for rocks
var _completion_amount: float = 0 :
	set(value):
		_completion_amount = min(value, 1.1)
		_completion_amount = max(_completion_amount, 0)
var modulation_colors = [Color("555555"), Color("FFFFFF")]
@export var rock_positions = [Vector2(199.0, 5.0), Vector2(199.0, 54.0)]
var sparks_scene = preload("res://sparks.tscn")


func _process(delta: float) -> void:
	_completion_amount -= decay_rate * delta
	$Control/ColorRect2/Label.text = str(int(_completion_amount * 4))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("key_generic"):
		_rock_position = true
		_completion_amount += key_press_rate
		%KeyHint.modulate = modulation_colors[0]
		%RockUpper.position = rock_positions[1]
		var sparksInstance = sparks_scene.instantiate()
		sparksInstance.emitting = true
		%SparksPoint.add_child(sparksInstance)
		return
	if event.is_action_released("key_generic"):
		_rock_position = false
		%KeyHint.modulate = modulation_colors[1]
		%RockUpper.position = rock_positions[0]
		return
	
		
