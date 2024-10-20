extends Camera2D

@export var player: CharacterBody2D
@export var focus: Node2D
var last_known_position: Vector2
var camera_limits: Rect2
func _ready():
	camera_limits = Rect2(Vector2(0, 0), get_viewport_rect().size)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player and player.is_inside_tree():
		# Actualiza la cámara a la posición actual del jugador
		global_position = player.global_position
		if camera_limits.has_point(player.global_position):
			player_outside_of_camera()
	else:
		# Fija la cámara en la última posición conocida del jugador
		global_position = focus.global_position

func player_outside_of_camera():
	Global.life = 0
