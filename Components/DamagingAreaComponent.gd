extends Area2D
class_name DamagingAreaComponent

@export var hitTags : Array[String]
@export var Damage : int

func AreaEntered(other_area : Area2D):
	var HitBox : HurtBoxComponent = other_area
	if HitBox != null:
		if HitBox.HurtBoxType in hitTags:
			HitBox.CauseHit(name, Damage)
