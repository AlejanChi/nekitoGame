extends CharacterBody2D 

@export_category("Enemy movement")
@export var SPEED = 50.0
@export var JUMP_VELOCITY = -400.0
@export var move_time: float = 4.0
@export var stop_time: float = 2.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var life = 2

# Variables para el temporizador y el movimiento
var timer: Timer
var move_direction: Vector2 = Vector2.ZERO
var is_moving: bool = false
#var target: CharacterBody2D = null

@onready var sprite = $Sprite2D
@onready var animation:AnimationNodeStateMachinePlayback = $Sprite2D/AnimationTree.get("parameters/playback")
@onready var detec_area = $detection_area
@onready var damage_dealer = $damage_dealer_area
@onready var collision_damage_shape = $damage_dealer_area/CollisionShape2D


func _ready():
	# Inicializa el temporizador
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = move_time
	timer.connect("timeout", _on_timer_timeout)
	_start_moving()

func _physics_process(delta):
	# Mueve el personaje si está en estado de movimiento
	if not is_on_floor():
		velocity.y = gravity*delta
		animation.travel("in_air")
	if not move_direction.x == 0:
		sprite.scale.x = move_direction.x
		if collision_damage_shape.position.x > 0:
			collision_damage_shape.position.x = collision_damage_shape.position.x * move_direction.x
#			print(collision_damage_shape.position.x)
		else:
			collision_damage_shape.position.x = (collision_damage_shape.position.x * -1) * move_direction.x
#			print(collision_damage_shape.position.x)
	if is_moving:
		velocity.x = move_direction.x * SPEED

		move_and_slide()

func _start_moving():
	is_moving = true
	timer.wait_time = move_time
	timer.start()
	# Elige una dirección de movimiento aleatoria (izquierda o derecha)
	var random_value = randi() % 2
	animation.travel("walking")
	if random_value == 0:
#		print("mover a la izquierda")
		move_direction = Vector2(-1, 0) # Moverse a la izquierda
	else:
#		print("mover a la derecha")
		move_direction = Vector2(1, 0) # Moverse a la derecha

func _stop_moving(case: String):
	is_moving = false
	match case:
		"idle":
			animation.travel("idle")
		#	move_direction = Vector2(0, 0)
			move_direction = move_direction*-1
			timer.wait_time = stop_time
			timer.start()
		"attack":
			animation.travel("attack")
			move_direction = Vector2(0, 0)
			timer.wait_time = 0.9
			timer.start()
		"die":
			animation.travel("die")
			move_direction = Vector2(0, 0)

func _on_timer_timeout():
	if is_moving:
		_stop_moving("idle")
	else:
		_start_moving()

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		var direction: Vector2 = (body.global_position - global_position).normalized()
		sprite.scale.x = round(direction.x)
		if collision_damage_shape.position.x > 0:
			collision_damage_shape.position.x = collision_damage_shape.position.x * direction.x
		else:
			collision_damage_shape.position.x = (collision_damage_shape.position.x * -1) * direction.x
#		print(round(direction.x))
		_stop_moving("attack")
	elif body.is_in_group("projectile"):
		take_damage()
	else:
		move_direction = move_direction*-1


func _on_damage_dealer_area_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage()

func take_damage():
	var tween: Tween = get_tree().create_tween().set_loops(5)
	life -= 1
	tween.tween_property(sprite,"modulate",Color.RED,0.08)
	tween.tween_property(sprite, "modulate", Color.WHITE,0.08)
	if life == 0:
		var tween2: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
		_stop_moving("die")
		tween2.tween_property(sprite,"modulate",Color.BLACK,0.8)



func _on_animation_tree_animation_finished(anim_name):
	if (anim_name == "die"):
		queue_free()
