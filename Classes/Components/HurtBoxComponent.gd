extends Area2D
class_name HurtBoxComponent

signal Hit(damage)
@export var HurtBoxType = ""

func CauseHit(_Hitter, Damage : int = 0):
	Hit.emit(Damage)
