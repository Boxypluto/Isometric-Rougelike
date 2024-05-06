extends Node2D
class_name Spin

@export var speed : float = 0

func _process(delta):
	rotation += delta * speed
