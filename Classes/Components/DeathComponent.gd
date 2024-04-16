extends Node2D
class_name DeathComponent

@export var ObjectParent : Node

signal Killed

func Kill():
	if ObjectParent != null:
		Killed.emit()
		ObjectParent.queue_free()
	else:
		push_error("A DeathComponent is missing it's parnent and cannot destroy it!")
