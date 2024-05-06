extends State
class_name SummonVinesState

var GrowSpotArray : Array[Node]
var EnemiesNode : Node2D
const VINE = preload("res://Objects/Enemies/Vine/Vine.tscn")

signal Complete

func enter():
	
	print(GrowSpotArray)
	
	for spot in GrowSpotArray:
		if spot.vine == null:
			await get_tree().create_timer(0.1).timeout
			var vine : Node2D = VINE.instantiate()
			EnemiesNode.add_child(vine)
			spot.vine = vine
			vine.global_position = spot.global_position
	
	Complete.emit()
