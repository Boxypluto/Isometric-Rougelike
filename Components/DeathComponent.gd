extends Node2D
class_name DeathComponent

@export var ObjectParent : Node

func Kill():
	if ObjectParent != null:
		ObjectParent.queue_free()
	else:
		push_error("A DeathComponent is missing it's parnent and cannot destroy it!")
