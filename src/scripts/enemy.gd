extends CharacterBody2D 


const SPEED = 50.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Variables para el temporizador y el movimiento
var timer: Timer
var move_direction: Vector2 = Vector2.ZERO
var move_time: float = 4.0
var stop_time: float = 2.0
var is_moving: bool = false
@onready var sprite = $Sprite2D
@onready var animation:AnimationNodeStateMachinePlayback = $Sprite2D/AnimationTree.get("parameters/playback")

func _ready():
	# Inicializa el temporizador
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = move_time
	timer.connect("timeout", _on_timer_timeout)
	_start_moving()

func _start_moving():
	is_moving = true
	timer.wait_time = move_time
	timer.start()
	# Elige una dirección de movimiento aleatoria (izquierda o derecha)
	var random_value = randi() % 2
	animation.travel("walking")
	if random_value == 0:
		print("mover a la izquierda")
		move_direction = Vector2(-1, 0) # Moverse a la izquierda
	else:
		print("mover a la derecha")
		move_direction = Vector2(1, 0) # Moverse a la derecha

func _stop_moving():
	is_moving = false
	animation.travel("idle")
	move_direction = Vector2(0, 0)
	timer.wait_time = stop_time
	timer.start()

func _on_timer_timeout():
	if is_moving:
		_stop_moving()
	else:
		_start_moving()

func _physics_process(delta):
	# Mueve el personaje si está en estado de movimiento
	if not is_on_floor():
		velocity.y = gravity*delta
	
	if not move_direction.x == 0:
		sprite.scale.x = move_direction.x
	if is_moving:
		velocity.x = move_direction.x * SPEED
		move_and_slide()
