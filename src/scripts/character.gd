extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -350.0
var life:int = 3
@onready var sprite = $Sprite2D
@onready var label:Label = $Label
@onready var animation:AnimationNodeStateMachinePlayback = $Sprite2D/AnimationTree.get("parameters/playback")
@onready var hitbox = $hitbox
@onready var damageDealer = $damage_dealer
@onready var wacareo_mark = $wacareo_origin

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var drink_count = 0
var input_vector = Vector2()
var death: bool = false

func get_axis() -> Vector2:
	input_vector.x = int(Input.is_action_pressed('ui_right')) - int(Input.is_action_pressed('ui_left'))
	return input_vector.normalized()

func _ready():
	Global.current_state = Global.states[0]

func _process(delta):
	state_machine()

func _physics_process(delta):
	#GIRO DEL SPRITE
	if not get_axis().x == 0:
		sprite.scale.x = get_axis().x
		hitbox.scale.x = get_axis().x
		damageDealer.scale.x = get_axis().x
		wacareo_mark.scale.x = get_axis().x
		if is_on_floor():
			animation.travel("walk")
	elif get_axis().x == 0 && is_on_floor():
		animation.travel("idle")
	
#	MOVIMIENTO EN EL EJE HORIZONTAL
	velocity.x = get_axis().x * SPEED
	
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

	
func take_damage():
	life -= 1

func drink():
	if (Global.score>0 && drink_count<=3):
		animation.travel("drink")
		print("bebiendo")
		drink_count += 1
		Global.score -= 1
	elif (Global.score>0 && drink_count>3):
		animation.travel("wacareo")
		print("wacareando")
		drink_count = 0
		Global.score -= 1
	elif Global.score == 0:
		print("Sin botellas")
	

func _on_hitbox_body_entered(body):
	if(body.is_in_group("dangerous")):
		take_damage()


