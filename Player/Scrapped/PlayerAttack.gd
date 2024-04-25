extends Area2D

@onready var player = $"../.."

signal AttackHasHit

func AttackEntered(HurtBox : HurtBoxComponent):
	if HurtBoxComponent == null: return
	HurtBox.CauseHit(name, 1)
	AttackHasHit.emit()
