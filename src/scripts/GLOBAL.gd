extends Node

@export var score:int = 0
@export var current_state = ""
const states: Dictionary = {
	0 : "idle",
	1 : "walking",
	2 : "inAir",
	3 : "attacking",
	4 : "drink",
	5 : "spit",
}
