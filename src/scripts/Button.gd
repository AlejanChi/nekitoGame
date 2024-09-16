extends Node2D

@onready var sprite = $Sprite2D
@onready var button_pressed = preload("res://src/images/objects/interactive_objects/action_button_pressed.png")
@onready var button_not_pressed = preload("res://src/images/objects/interactive_objects/action_button.png")
var pressed: bool = false
@export var action: String

signal button_pressed_signal(action)

func _on_area_2d_body_entered(body):
	if !pressed:
		print(action)
		sprite.texture = button_pressed
		$button_pressed.play()
		pressed = true
		emit_signal("button_pressed_signal",action)
