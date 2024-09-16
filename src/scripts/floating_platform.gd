extends PathFollow2D
@export var speed = 0.1

func _process(delta):
	progress_ratio += delta*speed
#	print(progress_ratio)
