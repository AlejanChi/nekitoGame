extends Control

func _process(delta):
	$Panel.position.x += 1

func _on_button_start_pressed():
	get_tree().change_scene_to_file("res://src/scenes/level.tscn")


func _on_button_quit_pressed():
	get_tree().quit() 
