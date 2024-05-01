extends Area2D

@onready var room = $"../../.."

func AreaEntered(HitBox : HurtBoxComponent):
	if HitBox.HurtBoxType == "Player":
		GameManager.DEBUG_MODE = false
		room.queue_free()
		GameManager.StartGame()
