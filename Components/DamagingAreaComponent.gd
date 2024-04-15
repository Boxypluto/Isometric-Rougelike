extends Area2D
class_name DamagingAreaComponent

@export var hitTags : Array[String]
@export var Damage : int

func AreaEntered(HitBox : HurtBoxComponent):
	print("Testing if " + HitBox.HurtBoxType + " is in: " + str(hitTags))
	if HitBox.HurtBoxType in hitTags:
		HitBox.CauseHit(name, Damage)
