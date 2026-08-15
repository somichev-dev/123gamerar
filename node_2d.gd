extends Node2D

func _ready() -> void:
	print(Achievements.achievements)
	Achievements.unlock("start_game") 
	print(Achievements.achievements)

func _process(delta: float) -> void:
	$Sprite2D.rotation_degrees += 360*delta if mouse else -360*delta

var mouse
func _on_area_2d_mouse_entered() -> void:
	mouse = true

func _on_area_2d_mouse_exited() -> void:
	mouse = false
