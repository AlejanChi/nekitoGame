extends CanvasLayer

@onready var score_marker = $MarginContainer/Label

func _process(delta):
	score_marker.text = "SCORE:" + str(Global.score)
