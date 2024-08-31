extends Node2D

@onready var animation = $AnimationPlayer
@export var route: String

func _next_level_travel():
	animation.play("nekito_entrance")

func _on_player_entered(body):
	if body.is_in_group("player"):
		body.movement = false
		body.global_position = self.global_position
		body.visible = false
		_next_level_travel()

func open_door():
	animation.play("open_door")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "nekito_entrance":
		print("ejecutando cambio de escena")
#		get_tree().change_scene_to_file(route)
		get_tree().quit()
