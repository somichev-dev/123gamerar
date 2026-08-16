extends Node2D


@export var transition_time: float = 2.0
@onready var state_nodes = [
	%SuccessSprite,
	%FailureSprite,
	%SurprisedSprite,
	%FasterSprite
]
var health_scenes = [
	"res://scenes/health/health_1.tscn",
	"res://scenes/health/health_2.tscn",
	"res://scenes/health/health_3.tscn",
	"res://scenes/health/health_4.tscn",
	"res://scenes/health/health_5.tscn",
]

func _ready() -> void:
	%TransitionTimer.start(transition_time)
	%PassedLevels.text = str(GamestateStorage.passed_levels)
	_disable_all_states()
	for i in min(Lives.lives, 5):
		if Lives.lives == 0: break
		%HealthContainer.add_child(load(health_scenes[i]).instantiate())
	state_nodes[GamestateStorage.transition_state].visible = true


func _on_transition_timer_timeout() -> void:
	get_tree().change_scene_to_file(LevelSelector.get_next_level())


func _disable_all_states() -> void:
	for n in state_nodes:
		n.visible = false
