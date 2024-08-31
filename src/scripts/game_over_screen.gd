extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.

func game_over():
	$"menu music".play()
	var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate", Color(1,1,1,1),0.2)

func _on_button_reload_pressed():
	get_tree().reload_current_scene()


func _on_button_quit_pressed():
	get_tree().quit()
