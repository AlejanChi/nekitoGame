extends Node2D

@onready var player = $character
@onready var bottles_container = $throwable_bottles
var mouse_position: Vector2
var game_over_executed: bool = false  # Variable para controlar si la función ya se ejecutó

func _ready():
	player.connect("throw_bottle", _on_throw_bottle)


func _on_throw_bottle(projectile, location):
	var bottle = projectile.instantiate()
	bottle.global_position = location

	# Calculamos la dirección hacia el mouse
	mouse_position = get_global_mouse_position()
	var direction = (mouse_position - location).normalized()
	var force = direction * 400
	bottle.apply_impulse(force, direction)

	# Añadimos el proyectil al contenedor de botellas
	bottles_container.add_child(bottle)
	Global.score -= 1

func game_over_screen():
	if Global.life == 0 and not game_over_executed:
		$music/AudioStreamPlayer.stop()
		print("hola se esta ejecutando estooooooooo")
		game_over_executed = true  # Marcar que la función ya se ejecutó

func _process(delta):
	game_over_screen()

