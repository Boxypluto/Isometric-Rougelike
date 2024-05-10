extends Node2D
class_name Room

@export var EnemiesDict : Dictionary
@onready var EnemiesNode = $"Y-Sortables/Enemies"

@export var RoomMode = "ENEMY"

@export var IsEnemyRoom : bool = true
var RoomEnded = false

func _ready():
	var EnemyGroupChildren : Array = EnemiesNode.get_children()
	for index in range(len(EnemyGroupChildren)):
		if EnemyGroupChildren[index] is Enemy:
			EnemiesDict[index] = EnemyGroupChildren[index]
			EnemyGroupChildren[index].IndexInEnemyDict = index
			EnemyGroupChildren[index].RoomNode = self

func _process(_delta):

	if IsEnemyRoom:
		var EnemiesGone : bool = true
		for key in EnemiesDict.values():
			if key != null:
				EnemiesGone = false
		if EnemiesGone and not GameManager.DEBUG_MODE and not RoomEnded:
			RoomEnded = true
			ProgressRooms()

func ProgressRooms():
	GameManager.ProgressRooms(self)

func OnHit(damage):
	material.set_shader_parameter("White", true)
	await get_tree().create_timer(0.1).timeout
	material.set_shader_parameter("White", false)
