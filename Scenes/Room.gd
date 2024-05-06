extends Node2D
class_name Room

@export var EnemiesDict : Dictionary
@onready var EnemiesNode = $"Y-Sortables/Enemies"

@export var RoomMode = "ENEMY"

func _ready():
	var EnemyGroupChildren : Array = EnemiesNode.get_children()
	for index in range(len(EnemyGroupChildren)):
		if EnemyGroupChildren[index] is Enemy:
			EnemiesDict[index] = EnemyGroupChildren[index]
			EnemyGroupChildren[index].IndexInEnemyDict = index
			EnemyGroupChildren[index].RoomNode = self

func _process(_delta):
	var IsEnemyRoom = false
	for key in EnemiesDict.values():
		if key != null:
			IsEnemyRoom = true
	if IsEnemyRoom == false and not GameManager.DEBUG_MODE: GameManager.ProgressRooms(self)
