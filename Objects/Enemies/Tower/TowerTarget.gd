extends Node2D

@onready var animation = $Mover/Animation
@onready var collision = $Mover/DamagingAreaComponent/CollisionShape2D
@onready var damager = $Mover/DamagingAreaComponent

@onready var crash : AudioStreamPlayer2D = $Mover/Crash

var FireTime : float = 0.2

func _physics_process(delta):
	animation.rotate(PI/20)

func Fire():
	collision.disabled = false
	animation.play("Fire")
	crash.play()
	await get_tree().create_timer(FireTime).timeout
	queue_free()
