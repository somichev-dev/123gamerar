extends Control

func _on_button_button_down() -> void:
	Achievements.unlock("start_game")
	$Background/Button/StickAnimPlayer.play("StartButtonAnim")


func _on_stick_anim_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file(LevelSelector.get_next_level())
