extends Projectile
class_name TowerProjectile

var Target : Vector2
var Speed : float = 64

signal NearTarget

@onready var sprites : AnimatedSprite2D = $Sprites
@onready var shadow : Sprite2D = $Shadow

var TotalDist : float

func _ready():
	sprites.play("Max")

func setup():
	TotalDist = position.distance_to(Target)

func _physics_process(delta):
	
	var x : float = sprites.position.x
	
	sprites.position.y = -((x-pow(TotalDist/2, 2)))+(pow(TotalDist/2, 2))
	print(-((x-pow(TotalDist/2.0, 2.0)))+(pow(TotalDist/2.0, 2.0)))
	
	if position.distance_to(Target) < 4:
		NearTarget.emit()
		queue_free()
	
	velocity = position.direction_to(Target)
	
	if position.distance_to(Target) < velocity.length():
		velocity = velocity.normalized() * position.distance_to(Target)
	
	velocity.y /= 2
	
	move_and_collide(velocity)
