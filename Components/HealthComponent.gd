extends Node2D
class_name HealthComponent

@export var InitialMaxHealth : int
@export var InvincibilityState : bool = false

signal HealthReachedZero

@onready var Health : int = InitialMaxHealth
@onready var MaxHealth : int = InitialMaxHealth
@onready var Invincible : bool = InvincibilityState

func DealDamage(amount : int, ignores_invincibility : bool = false):
	if ignores_invincibility or not Invincible: 
		Health -= amount
	if Health <= 0:
		HealthReachedZero.emit()

func HealDamage(amount : int):
	Health = clamp(Health + amount, -INF, MaxHealth)
