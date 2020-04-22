extends Node

var activeState
enum STATES{
	AGGRESSIVE,
	WANDER,
	IDLE,
	WALK_AWAY
}

func _ready():
	activeState = STATES.IDLE

func enterState(state:String)->void:
	if state == "aggressive":
		activeState = STATES.AGGRESSIVE
	elif state == "wander":
		activeState = STATES.WANDER
	elif state == "idle":
		activeState = STATES.IDLE
	elif state == "walk_away":
		activeState = STATES.WALK_AWAY
							
func getActiveState():
	return activeState
