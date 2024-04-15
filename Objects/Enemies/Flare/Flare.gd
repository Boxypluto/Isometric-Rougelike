extends CharacterBody2D

@onready var health : HealthComponent = $HealthComponent
@onready var death : DeathComponent = $DeathComponent

func FlareIsHit(damage):
	health.DealDamage(damage)

func OnHealthZero():
	death.Kill()
