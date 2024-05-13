extends Projectile

var Speed = 1
@onready var sprite = $Sprite

func HitPlayer():
	queue_free()

func DeathTimeout():
	queue_free()

func _physics_process(delta):
	velocity = Vector2.from_angle(sprite.rotation * Speed)
	velocity.y /= 2
	move_and_collide(velocity)
