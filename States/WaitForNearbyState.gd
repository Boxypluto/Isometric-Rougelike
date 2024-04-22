extends State
class_name WaitForNearbyState

var Actor : Node2D
var Target : Node2D

var Distance

signal NearTo

func update(_delta : float):
	if Actor and Target:
		if Actor.position.distance_to(Target.position) <= Distance:
			NearTo.emit()
