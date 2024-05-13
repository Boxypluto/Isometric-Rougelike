extends State
class_name PedalVolleyState

const PEDAL = preload("res://Scenes/Bossfights/Floweye/PedalProjectile.tscn")
var FireTimes : int
var FireNode : Node2D
var TargetNode : Node2D
var ProjectileOwner : Node2D
var sound : AudioStreamPlayer2D

signal Complete

func enter():
	for fire in range(FireTimes):
		sound.play()
		var pedal : PedalProjectile = PEDAL.instantiate()
		pedal.position = FireNode.position
		pedal.Direction = FireNode.global_position.direction_to(TargetNode.global_position)
		pedal.ImageParentNode = ProjectileOwner
		ProjectileOwner.add_child(pedal)
		await get_tree().create_timer(0.5).timeout
	Complete.emit()
