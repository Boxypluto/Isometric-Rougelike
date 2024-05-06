extends State
class_name ShootFlowersState

var PositionsDict : Dictionary
var Parent : Node2D

const FLOWER = preload("res://Scenes/Bossfights/Floweye/FlowerProjectile.tscn")

signal Complete

func enter():
	
	var choice : int = randi_range(0, 1)
	
	for positions in PositionsDict.values():
		
		var start : Node2D = positions[choice]
		var end : Node2D = positions[abs(choice - 1)]
		
		var flower = FLOWER.instantiate()
		Parent.add_child(flower)
		flower.global_position = start.global_position
		flower.TargetPos = end.global_position
		
		print("FLOWER INST AT: " + str(start.position))
		
		choice = abs(choice - 1)
	
	Complete.emit()
