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

func OnDeath():
	RoomNode.EnemiesDict.erase(IndexInEnemyDict)
