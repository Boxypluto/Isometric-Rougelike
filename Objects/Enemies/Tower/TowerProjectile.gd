extends Projectile
class_name TowerProjectile

var Target : Vector2
var Speed : float = 2

var TargetNode : Node2D

signal NearTarget

@onready var sprites : AnimatedSprite2D = $Sprites
@onready var shadow : Sprite2D = $Shadow

var TotalDist : float

func _ready():
	sprites.play("Max")

func _physics_process(delta):
	
	var x : float = TotalDist - position.distance_to(Target)
	var MidPoint = (-24+TotalDist)/2
	var MaxHeight = abs(((MidPoint+24)*(MidPoint-TotalDist))/100)
	
	sprites.position.y = ((x+24)*(x-TotalDist))/100
	
	var y = abs(sprites.position.y)
	
	var percent = (y)/MaxHeight
	print(percent)
	
	if percent > 0.9:sprites.play("Normal")
	elif percent > 0.8:sprites.play("Between")
	else: sprites.play("Max")
	
	visible = true
	
	if position.distance_to(Target) < 4:
		NearTarget.emit()
		TargetNode.Fire()
		queue_free()
	
	velocity = position.direction_to(Target)
	
	if position.distance_to(Target) < velocity.length():
		velocity = velocity.normalized() * position.distance_to(Target)
	
	velocity.y /= 2
	velocity *= Speed
	
	move_and_collide(velocity)
