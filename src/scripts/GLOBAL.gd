extends Node

@export var score:int = 0
@export var current_state = ""
@export var life = 3
@export var drink_count = 0
const states: Dictionary = {
	0 : "idle",
	1 : "walking",
	2 : "inAir",
	3 : "attacking",
	4 : "drink",
	5 : "spit",
}

func _process(delta):
	if score >= 5:
		score = 5
