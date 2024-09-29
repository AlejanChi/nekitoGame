extends Node2D

@export var vector_direction:int
@onready var animation = $AnimationPlayer
var speed = 5
#var tween: Tween = get_tree().create_tween()
# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("flying")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.rotation += 0.4
	position.x += vector_direction*speed


func _on_area_2d_body_entered(body):
	if (body):
		if (body.is_in_group("player")):
			body.take_damage()
			animation.play("explode")
		else:
			animation.play("explode")


func _on_animation_player_animation_finished(anim_name):
	if(anim_name=="explode"):
		queue_free()
