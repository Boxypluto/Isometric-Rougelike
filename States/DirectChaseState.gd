extends State
class_name DirectChaseState

var Target : Node2D
var Actor : CharacterBody2D
var NearDist : float
var Speed : float

signal NearTo

func physics_update(_delta):
	
	if Actor.position.distance_to(Target.position) <= NearDist:
		NearTo.emit()
	Actor.velocity = Actor.position.direction_to(Target.position)
	Actor.velocity *= Speed
	
	if Actor.position.distance_to(Target.position) < Actor.velocity.length():
		Actor.velocity = Actor.velocity.normalized() * Actor.position.distance_to(Target.position)
	
	Actor.velocity.y /= 2
	
	Actor.move_and_slide()
