extends Control

func _on_button_button_down() -> void:
	Achievements.unlock("start_game")
	get_tree().change_scene_to_file("res://scenes/rock_bonfire.tscn")
