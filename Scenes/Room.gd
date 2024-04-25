extends Node2D
class_name Room

@export var EnemiesDict : Dictionary
@onready var EnemiesNode = $"Y-Sortables/Enemies"

const DEBUG_MODE = false

func _ready():
	var EnemyGroupChildren : Array = EnemiesNode.get_children()
	for index in range(len(EnemyGroupChildren)):
		if EnemyGroupChildren[index] is Enemy:
			EnemiesDict[index] = EnemyGroupChildren[index]
			EnemyGroupChildren[index].IndexInEnemyDict = index
			EnemyGroupChildren[index].RoomNode = self

func _process(_delta):
	var IsEn = false
	for key in EnemiesDict.values():
		if key != null:
			IsEn = true
	if IsEn == false: GameManager.ProgressRooms(self)
