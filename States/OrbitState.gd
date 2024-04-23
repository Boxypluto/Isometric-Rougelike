extends State
class_name OrbitState

var Target : Node2D
var Actor : CharacterBody2D

var Speed
var Smoothing
var Distance
var Angle

func enter():
	Angle = Target.position.angle_to(Actor.position)

func physics_update(_delta):
	Angle += (Speed/Distance)
	var Point : Vector2 = Target.position + (Vector2(cos(Angle-(PI/2)), sin(Angle-(PI/2))) * Distance)
	Actor.position =  Point #Actor.position.lerp(Point, Smoothing)
