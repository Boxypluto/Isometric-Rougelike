extends Node2D
class_name DeathComponent

@export var ObjectParent : Node
@export var IsEnemy : bool = false

@onready var RoomNode : Room = get_tree().current_scene

func _ready():
	RoomNode.EnemiesInScene += 1
	EnemyDeath.connect(RoomNode.OnEnemyDeath())

signal EnemyDeath

func Kill():
	if ObjectParent != null:
		if IsEnemy: EnemyDeath.emit()
		ObjectParent.queue_free()
	else:
		push_error("A DeathComponent is missing it's parnent and cannot destroy it!")
