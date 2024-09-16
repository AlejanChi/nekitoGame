extends Node2D
@onready var button = $interactive_objects/Button
@onready var door = $interactive_objects/Door

func _process(delta):
	button.connect("button_pressed_signal", on_door_open);

func on_door_open(action):
	door.open_door()
