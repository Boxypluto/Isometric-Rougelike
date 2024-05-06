extends State
class_name GuardianLaserState

var Laser : Panel
var Target : Node2D
var Speed : float = 0.25
var Collision : CollisionPolygon2D
var Parent : Node2D

var IsMovingLaser : bool = true

signal Complete

var frames : float

func _process(delta):
	frames += 1
	Laser.scale.x = 1
	if IsMovingLaser:
		var DirectionTo = Parent.global_position.direction_to(Target.global_position)
		DirectionTo = Vector2(DirectionTo.x, DirectionTo.y * 2.0)
		var RotateTo : float = DirectionTo.angle() - PI/2
		Laser.rotation = rotate_toward(Laser.rotation, RotateTo, Speed * delta)
	else:
		pass
		Laser.scale.x = 1 + (sin(frames / 10.0)*0.1)

func enter():
	IsMovingLaser = true
	Collision.disabled = true
	Laser.modulate.a = 0.1
	await get_tree().create_timer(3).timeout
	Laser.modulate.a = 1
	IsMovingLaser = false
	Collision.disabled = false
	await get_tree().create_timer(2).timeout
	Collision.disabled = true
	Laser.modulate.a = 0
	Complete.emit()
