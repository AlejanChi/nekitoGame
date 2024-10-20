extends Node2D

@onready var player = $character
@onready var bottles_container = $throwable_bottles
var mouse_position: Vector2
var game_over_executed: bool = false  # Variable para controlar si la función ya se ejecutó

func game_over_screen():
	if Global.life == 0 and not game_over_executed:
		$music/AudioStreamPlayer.stop()
		print("hola se esta ejecutando estooooooooo")
		game_over_executed = true  # Marcar que la función ya se ejecutó

func _process(delta):
	game_over_screen()

