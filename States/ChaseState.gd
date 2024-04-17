extends State

@export var AvoidToucing : Array[int]

var DirectionVectors : Array[Vector2] = [
	Vector2(0, -1),
	Vector2(1, -1),
	Vector2(1, 0),
	Vector2(1, 1),
	Vector2(0, 1),
	Vector2(-1, 1),
	Vector2(-1, 0),
	Vector2(-1, -1),
	]

var InterestVectors : Array[Vector2] = []

func physics_update(_delta):
	pass
