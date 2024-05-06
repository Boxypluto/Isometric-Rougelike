extends Projectile

var TargetPos : Vector2
var Speed : float = 256

func _process(delta):
	velocity = global_position.direction_to(TargetPos) * Speed * delta
	velocity.y /= 2
	global_position += velocity
	
	if global_position.distance_to(TargetPos) < 2:
		queue_free()
