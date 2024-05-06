extends Area2D
class_name DamagingAreaComponent

@export var hitTags : Array[String]
@export var Damage : int

signal Success

func _ready():
	if not area_entered.is_connected(Callable(AreaEntered)):
		area_entered.connect(Callable(AreaEntered))

func AreaEntered(HitBox : HurtBoxComponent):
	if HitBox.HurtBoxType in hitTags:
		HitBox.CauseHit(name, Damage)
		Success.emit()
