extends Node

enum TransitionScreenState {
	GOOD,
	BAD,
	SURPRISED,
	FASTER
}

var transition_state: TransitionScreenState = TransitionScreenState.SURPRISED     ## for transition screen state
var passed_levels: int = 0        ## score keeping
var difficulty_scale: float = 1.0 ## increases as the game goes on
