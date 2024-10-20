extends CharacterBody2D

@export var life = 1

func take_damage():
	life -= 1
func paralized():
	life-=1
func _process(delta):
	if(life==0):
		die()

func die():
	var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	# Configuración del Tween para la rotación
	tween.tween_property(self, "rotation", 180, 0.3)

	# Configuración del Tween para la posición en Y
	tween.tween_property(self, "position:y", self.position.y + 100, 0.6)

	# Configuración del Tween para la transparencia
	tween.tween_property(self, "modulate:a", 0.0, 0.6)
	tween.tween_callback(self.queue_free)
