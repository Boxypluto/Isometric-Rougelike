extends State
class_name OrbitState

var Target : Node2D
var Actor : CharacterBody2D

var ActorSprite : Node2D
var SpriteRotationOffset : float = 0

var Speed
var Smoothing
var Distance
var Angle

func enter():
	Angle = Target.position.angle_to_point(Actor.position)

func physics_update(_delta):
	
	if ActorSprite: ActorSprite.rotation = Target.position.angle_to_point(Actor.position) + SpriteRotationOffset
	
	Angle += (Speed/Distance)
	var Point : Vector2 = Target.position + ((Vector2(cos(Angle), sin(Angle)) * Distance) / Vector2(1, 2))
	Actor.position =  Actor.position.lerp(Point, Smoothing)
