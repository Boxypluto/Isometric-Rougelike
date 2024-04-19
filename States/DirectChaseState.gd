extends State

var Actor : CharacterBody2D
var Target : Node2D

signal NearTo
var NearToDistance


func physics_update(_delta):
	Actor.velocity = Vector2.from_angle(Actor.position.angle_to_point(Target.position))
