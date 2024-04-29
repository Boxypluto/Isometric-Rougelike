extends Node2D

@onready var animation = $Mover/Animation
@onready var collision = $Mover/DamagingAreaComponent/CollisionShape2D
@onready var damager = $Mover/DamagingAreaComponent

var FireTime : float = 0.2

func _physics_process(delta):
	animation.rotate(PI/20)

func Fire():
	collision.disabled = false
	animation.play("Fire")
	await get_tree().create_timer(FireTime).timeout
	queue_free()
