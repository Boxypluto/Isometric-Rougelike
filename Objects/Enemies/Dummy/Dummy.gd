extends CharacterBody2D

@onready var health : HealthComponent = $HealthComponent
@onready var death : DeathComponent = $DeathComponent
@onready var hurt_box : HurtBoxComponent = $HurtBoxComponent

func DummyIsHit(damage):
	health.DealDamage(damage)

func OnZeroHealth():
	death.Kill()
