extends State
class_name MoveToPointState

var TargetPos : Vector2
var Actor : CharacterBody2D
var Speed : float

signal AtPoint

func physics_update(_delta):
	
	Actor.velocity = Actor.position.direction_to(TargetPos)
	
	Actor.velocity *= Speed
	
	if Actor.position.distance_to(TargetPos) < 1:
		AtPoint.emit()
	
	Actor.move_and_slide()
