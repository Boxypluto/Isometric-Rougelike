extends State
class_name SpawnEnemiesState

var SpawnSpotArray : Array[Node]
var EnemiesNode : Node2D
var ENEMY : PackedScene

signal Complete

func enter():
	
	for spot in SpawnSpotArray:
		await get_tree().create_timer(0.1).timeout
		var bird : Node2D = ENEMY.instantiate()
		EnemiesNode.add_child(bird)
		bird.global_position = spot.global_position
	
	Complete.emit()
