extends Node2D
class_name Room

@export var EnemiesDict : Dictionary
@onready var EnemiesGroup = $"Y-Sortables/Enemies"


func _ready():
	var EnemyGroupChildren : Array = EnemiesGroup.get_children()
	for index in range(len(EnemyGroupChildren)):
		if EnemyGroupChildren[index] is Enemy:
			EnemiesDict[index] = EnemyGroupChildren[index]
			EnemyGroupChildren[index].IndexInEnemyDict = index
			EnemyGroupChildren[index].RoomNode = self
