extends CharacterBody2D
class_name Enemy

@onready var health : HealthComponent = $HealthComponent
@onready var hurt_box : HurtBoxComponent = $HurtBoxComponent
@onready var death : DeathComponent = $DeathComponent

const FLASH_MAT : ShaderMaterial = preload("res://Objects/Enemies/EnemyFlashMAT.tres")

var IndexInEnemyDict : int
var RoomNode : Room

signal EnemyKilled
signal FlashEnded

func _ready():
	print(name + " is ready!")
	death.Killed.connect(Callable(self, "OnDeath"))
	hurt_box.Hit.connect(Callable(self, "OnHit"))
	material = FLASH_MAT.duplicate()

func OnDeath():
	GameManager.EnemiesDefeated += 1
	if RoomNode:
		RoomNode.EnemiesDict.erase(IndexInEnemyDict)

func OnHit(damage):
	material.set_shader_parameter("White", true)
	await get_tree().create_timer(0.1).timeout
	material.set_shader_parameter("White", false)
	FlashEnded.emit()
