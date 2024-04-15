extends Node2D
class_name Room

@export var EnemiesInScene : int

func OnEnemyDeath():
	EnemiesInScene -= 1
