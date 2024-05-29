extends Node2D

func _on_area_2d_body_entered(body):
	Global.score += 1
	print(Global.score)
	queue_free()
