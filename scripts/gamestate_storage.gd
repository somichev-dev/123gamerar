extends Node

enum TransitionScreenState {
	GOOD,
	BAD,
	SURPRISED,
	FASTER
}

## for transition screen state
var transition_state: TransitionScreenState = TransitionScreenState.SURPRISED
## difficulty increment
var difficulty_increment: float = 0.2
var difficulty_period: int = 4
## score keeping
var passed_levels: int = 0
## increases as the game goes on
var difficulty_scale: float = 1.0

func check_diff_increase() -> bool:
	return (
		(passed_levels % difficulty_period == 0) 
	and (passed_levels > 0) 
	and (transition_state != TransitionScreenState.BAD)
	)

func increase_difficulty() -> void:
	difficulty_scale += difficulty_increment

func reset_state() -> void:
	transition_state = TransitionScreenState.SURPRISED
	passed_levels = 0
	difficulty_scale = 1.0
