extends Area2D
class_name HurtBoxComponent

signal Hit(damage)
@export var HurtBoxType = ""

func _init():
	#mouse_entered.connect(CauseHit.bind("Mouse", 1))
	pass

func CauseHit(_Hitter, Damage : int = 0):
	Hit.emit(Damage)
