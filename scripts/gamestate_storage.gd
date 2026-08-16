extends Node

enum TransitionScreenState {
	GOOD,
	BAD,
	SURPRISED,
	FASTER
}

## for transition screen state
var transition_state: TransitionScreenState = TransitionScreenState.SURPRISED
## score keeping
var passed_levels: int = 0
## increases as the game goes on
var difficulty_scale: float = 1.0


func reset_state() -> void:
	transition_state = TransitionScreenState.SURPRISED
	passed_levels = 0
	difficulty_scale = 1.0
