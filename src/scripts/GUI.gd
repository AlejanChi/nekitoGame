extends CanvasLayer

@onready var score_marker = $MarginContainer/Node2/Label
@onready var life_marker = $MarginContainer/Label2
@onready var drink_counter = $MarginContainer/Node/Panel/ProgressBar
@onready var heart_full = preload("res://src/images/objects/GUI/heart_full.png")
@onready var heart_void = preload("res://src/images/objects/GUI/heart_void.png")
var game_over_executed: bool = false
@onready var hearts:Dictionary = {
	0: $MarginContainer/Node/Panel/heart1,
	1: $MarginContainer/Node/Panel/heart2,
	2: $MarginContainer/Node/Panel/heart3
}
func _ready():
	Global.life = 3

func _process(delta):
	score_marker.text = str(Global.score)
	life_ctrl()
	drink_counter.value = Global.drink_count*10
	if Global.life == 0 and not game_over_executed:
		$Control.game_over()
		game_over_executed = true

func life_ctrl():
	match Global.life:
		0:
			hearts[0].texture = heart_void
			hearts[1].texture = heart_void
			hearts[2].texture = heart_void
		1:
			hearts[0].texture = heart_full
			hearts[1].texture = heart_void
			hearts[2].texture = heart_void
		2:
			hearts[0].texture = heart_full
			hearts[1].texture = heart_full
			hearts[2].texture = heart_void
		3:
			hearts[0].texture = heart_full
			hearts[1].texture = heart_full
			hearts[2].texture = heart_full


