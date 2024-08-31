extends CharacterBody2D

@export_category("Movement")
@export var SPEED = 100.0
@export var JUMP_VELOCITY = -350.0
@export var movement:bool = true

@onready var sprite = $Sprite2D
@onready var label:Label = $Label
@onready var animation:AnimationNodeStateMachinePlayback = $Sprite2D/AnimationTree.get("parameters/playback")
@onready var hitbox = $hitbox
@onready var wacareo_mark = $wacareo_origin
var mouse_position = Vector2() 



#VARIABLES PARA DISPARO DE PROYECTILES
var projectile_instance = preload("res://src/scenes/proyectil.tscn")
signal throw_bottle(projectile, location)
var shoot_cursor = preload("res://src/images/objects/GUI/pointer_shoot-Sheet.png")



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var input_vector = Vector2()

func get_axis() -> Vector2:
	input_vector.x = int(Input.is_action_pressed('right')) - int(Input.is_action_pressed('left'))
	return input_vector.normalized()

func _ready():
	Global.current_state = Global.states[0]

func _process(delta):
	state_machine()
	mouse_position = get_global_mouse_position()
func _physics_process(delta):
	#GIRO DEL SPRITE
	move_controler(movement)
	
#	APLICACION DE LA GRAVEDAD
	if not is_on_floor():
		velocity.y += gravity * delta
#		Global.current_state = Global.states[2]

#	SALTO
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.travel("jump")
		
#	ACCION DE BEBER
	if Input.is_action_just_pressed("drink_a_bottle") and is_on_floor():
		drink()
	if Input.is_action_pressed("throw") and is_on_floor() and (Global.score > 0):
		Input.set_custom_mouse_cursor(shoot_cursor,Input.CURSOR_ARROW)
		animation.travel("throw")
		movement = false
		var direction: Vector2 = (mouse_position-self.global_position).normalized().sign()
		print(direction.x)
		if direction.x==0:
			direction.x+=1
		sprite.scale.x = direction.x
		hitbox.scale.x = direction.x
		if wacareo_mark.position.x > 0:
			wacareo_mark.position.x = wacareo_mark.position.x * sprite.scale.x
		else:
			wacareo_mark.position.x = (wacareo_mark.position.x * -1) * sprite.scale.x
		print("La posicion de la marca es: " + str(wacareo_mark.position.x))
	if Input.is_action_just_released("throw") and is_on_floor() and (Global.score > 0):
		animation.travel("throw_2")
		await get_tree().create_timer(0.8).timeout
		movement = true
		Input.set_custom_mouse_cursor(null)
	if (Global.life == 0):
		death()
	move_and_slide()


func state_machine() -> void:
	match animation.get_current_node():
		"idle":
			label.text = "STATE: idle"
		"walk":
			label.text = "STATE: walk"
		"jump":
			label.text = "STATE: jump"
		"drink":
			label.text = "STATE: drink"
		"wacareo":
			label.text = "SCORE: wacareo"
		"damage":
			label.text = "STATE: death"


func drink():
	if (Global.score>0 && Global.drink_count<=3 && Global.life<3):
		movement = false
		animation.travel("drink")
		print("bebiendo")
		Global.score -= 1
	elif (Global.score>0 && Global.drink_count>3 && Global.life<3):
		movement = false
		animation.travel("wacareo")
		print("wacareando")
		Global.score -= 1
	elif Global.score == 0:
		print("Sin botellas")
	elif Global.life == 3:
		print("Vida al maximo")


func throwing_bottle():
	throw_bottle.emit(projectile_instance,wacareo_mark.global_position)

func move_controler(enabled:bool):
	if(enabled):
		if not get_axis().x == 0:
			sprite.scale.x = get_axis().x
			hitbox.scale.x = get_axis().x
			wacareo_mark.position.x = wacareo_mark.position.x * get_axis().x
			if is_on_floor():
				animation.travel("walk")
		elif get_axis().x == 0 && is_on_floor():
			animation.travel("idle")
	#	MOVIMIENTO EN EL EJE HORIZONTAL
		velocity.x = get_axis().x * SPEED
	else:
		velocity.x = 0
		animation.travel("idle")

func drink_count_ctrl():
	if (Global.drink_count <=3):
		Global.drink_count += 1
		Global.life += 1
	else:
		Global.drink_count = 0

func take_damage():
#	animation.travel("hurt")
	var tween: Tween = get_tree().create_tween().set_loops(12)
	var movement_tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite,"modulate",Color.RED,0.08)
	tween.tween_property(sprite, "modulate", Color.WHITE,0.08)
	$SFX/damage.play()
	Global.life -= 1
	await get_tree().create_timer(1).timeout

func death():
	animation.travel("damage")
	movement = false
	self.remove_from_group("player")

func _on_animation_tree_animation_finished(anim_name):
	if(anim_name != "damage" || "throw"):
		movement = true
	elif (anim_name == "damage"):
		pass
