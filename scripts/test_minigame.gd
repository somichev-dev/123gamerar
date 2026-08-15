extends Node2D

var mouse


func _ready() -> void:
	Achievements.unlock("start_game") 
	print(Achievements.achievements)


func _process(delta: float) -> void:
	$Sprite2D.rotation_degrees += 360*delta if mouse else -360*delta


func _on_area_2d_mouse_entered() -> void: mouse = true
func _on_area_2d_mouse_exited() -> void: mouse = false
