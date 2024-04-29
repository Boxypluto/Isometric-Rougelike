extends Area2D
class_name DamagingAreaComponent

@export var hitTags : Array[String]
@export var Damage : int

func AreaEntered(HitBox : HurtBoxComponent):
	if HitBox.HurtBoxType in hitTags:
		HitBox.CauseHit(name, Damage)
