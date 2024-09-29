extends Node2D

@export var sprite_Texture:Texture2D
@onready var sprite = $Sprite2D
func _ready():
	sprite.texture = sprite_Texture

