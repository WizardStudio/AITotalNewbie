extends Node

var activeState
enum STATES{
	AGGRESSIVE,
	IDLE,
	HURT,
	DEATH,
	WALL_HIT,
	OUT_OF_REACH
}

func _ready():
	activeState = STATES.IDLE

func enterState(state:String)->void:
	if state == "aggressive":
		activeState = STATES.AGGRESSIVE
	elif state == "hurt":
		activeState = STATES.HURT
	elif state == "idle":
		activeState = STATES.IDLE
	elif state == "death":
		activeState = STATES.DEATH
	elif state == "wall_hit":
		activeState = STATES.WALL_HIT
	elif state == "out_of_reach":
		activeState = STATES.OUT_OF_REACH
							
func getActiveState():
	return activeState



func toString(stateIndex:int)->String:
	match stateIndex:
		0:
			return "aggressive"
		1:
			return "idle"
		2:
			return "hurt"
		3:
			return "death"
		4:
			return "wall_hit"
		5:
			return "out_of_reach"
			
	return "undefined"


