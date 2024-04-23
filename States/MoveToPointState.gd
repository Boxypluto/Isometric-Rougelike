extends State
class_name MoveToPointState

var TargetPos : Vector2
var Actor : Node2D
var Speed : float

var Velocity : Vector2

var ActorSprite : Node2D
var SpriteRotationOffset : float = 0

signal AtPoint

func physics_update(_delta):
	
	if ActorSprite: ActorSprite.rotation = TargetPos.angle_to_point(Actor.position) + SpriteRotationOffset
	
	Velocity = Actor.position.direction_to(TargetPos)
	
	Velocity *= Speed
	
	if Actor.position.distance_to(TargetPos) < Velocity.length():
		Velocity = Velocity.normalized() * Actor.position.distance_to(TargetPos)
	if Actor.position.distance_to(TargetPos) < 1:
		AtPoint.emit()
	
	Actor.position += Velocity
