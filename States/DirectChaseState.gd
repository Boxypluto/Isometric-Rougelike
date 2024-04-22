extends State
class_name DirectChaseState

var Target : Node2D
var Actor : CharacterBody2D
var NearDist : float
var Speed : float

signal NearTo

func enter():
	Target = get_node("root/Y-Sortables/Player")

func physics_update(_delta):
	
	if Actor.global_position.distance_to(Target.global_position) <= NearDist:
		NearTo.emit()
	
	Actor.velocity = Vector2.from_angle(Actor.position.angle_to(Target.position))
	Actor.velocity *= Speed
	
	Actor.move_and_slide()
