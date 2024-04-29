extends CharacterBody2D
class_name Enemy

@onready var health : HealthComponent = $HealthComponent
@onready var hurt_box : HurtBoxComponent = $HurtBoxComponent
@onready var death : DeathComponent = $DeathComponent

var IndexInEnemyDict : int
var RoomNode : Room

signal EnemyKilled

func _ready():
	death.Killed.connect(Callable(self, "OnDeath"))
	hurt_box.Hit.connect(Callable(self, "OnHit"))

func OnDeath():
	RoomNode.EnemiesDict.erase(IndexInEnemyDict)

func OnHit(damage):
	material.set_shader_parameter("White", true)
	await get_tree().create_timer(0.1).timeout
	material.set_shader_parameter("White", false)
