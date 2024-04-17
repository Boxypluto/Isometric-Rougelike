@tool
extends Node2D

@export var RaycastLength : float = 32
@export var ChangeLength : bool = false

func _process(delta):
	if Engine.is_editor_hint() and ChangeLength:
		for cast in get_children():
			if cast is RayCast2D:
				cast.target_position = Vector2(0, RaycastLength)
