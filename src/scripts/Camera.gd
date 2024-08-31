extends Camera2D

@export var player: CharacterBody2D
@export var focus: Node2D
var last_known_position: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player and player.is_inside_tree():
		# Actualiza la cámara a la posición actual del jugador
		global_position = player.global_position
	else:
		# Fija la cámara en la última posición conocida del jugador
		global_position = focus.global_position
