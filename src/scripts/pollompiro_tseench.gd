extends CharacterBody2D
@export_category("Enemy movement")
@export var SPEED = 50.0
#@export var JUMP_VELOCITY = -400.0
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
@onready var bullet_born = $Marker2D
@onready var damage_receiver = $damage_receiver
@onready var bullet = preload("res://src/scenes/tseench_power_bullet.tscn")
@onready var projectile_box = $Projectile_box

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
#		print(sprite.scale.x)
		if(bullet_born.position.x > 0 && $Sprite2D2.position.x>0):
			bullet_born.position.x = bullet_born.position.x * sprite.scale.x
			$Sprite2D2.position.x = $Sprite2D2.position.x * sprite.scale.x
#			print("Esta es la ubicacion del hechizo positiva: ",$Sprite2D2.position.x)
		else:
			bullet_born.position.x = (bullet_born.position.x * -1) * sprite.scale.x
			$Sprite2D2.position.x = ($Sprite2D2.position.x * -1) * sprite.scale.x
#			print("Esta es la ubicacion del hechizo negativa: ",$Sprite2D2.position.x)
	if is_moving:
		velocity.x = move_direction.x * SPEED

		move_and_slide()

func _start_moving():
	is_moving = true
	timer.wait_time = move_time
	timer.start()
	# Elige una dirección de movimiento aleatoria (izquierda o derecha)
	var random_value = randi() % 2
	animation.travel("walk")
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
		"shoot":
			animation.travel("shoot")
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
#		print(round(direction.x))
		_stop_moving("shoot")
	else:
		move_direction = move_direction*-1

func take_damage():
	var tween: Tween = get_tree().create_tween().set_loops(5)
	life -= 1
	tween.tween_property(sprite,"modulate",Color.RED,0.08)
	tween.tween_property(sprite, "modulate", Color.WHITE,0.08)
	if life == 0:
#		var tween2: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
		_stop_moving("die")

func _on_damage_receiver_body_entered(body):
	print("Objeto detectado: ",body)
	if body.is_in_group("projectile"):
		print("GOLPE DE PROYECTIL RECIBIDO")
		take_damage()

func cast_bullet():
	var cast = bullet.instantiate()
	cast.vector_direction = sprite.scale.x
	cast.global_position = bullet_born.global_position
	projectile_box.add_child(cast)

func paralized():
	_stop_moving("idle")
	var tween: Tween = get_tree().create_tween().set_loops(3)
	tween.tween_property(sprite,"modulate",Color.TRANSPARENT,0.08)
	tween.tween_property(sprite, "modulate", Color.WHITE,0.08)
