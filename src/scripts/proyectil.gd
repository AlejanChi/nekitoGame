extends RigidBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation = $AnimationPlayer
var direction: Vector2 = (self.global_position - get_global_mouse_position()).normalized()
# Called when the node enters the scene tree for the first time.

func _ready():
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property($Sprite2D,"rotation",180,0.6)
	self.apply_torque(1)

func _on_area_2d_body_entered(body):
	if !body.has_method("throwing_bottle") && (!body.is_in_group("player") && !body.is_in_group("projectile")):
		animation.play("broke")
		print("Hola me estouy ejecutando sin mas, el body es")
		print(body)
		self.FREEZE_MODE_STATIC
		animation.speed_scale = 5
		self.apply_torque(-1)
